/* SPDX-License-Identifier: GPL-2.0-or-later */
/*
 * ata_id - reads product/serial number from ATA drives
 *
 * Copyright © 2009-2010 David Zeuthen <zeuthen@gmail.com>
 */

#include <ctype.h>
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <linux/bsg.h>
#include <linux/hdreg.h>
#include <scsi/scsi.h>
#include <scsi/scsi_ioctl.h>
#include <scsi/sg.h>
#include <inttypes.h>
#include <uchar.h>
#include <stdint.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include <sys/ioctl.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#define UNIQ_T(x, uniq) __unique_prefix_ ## x ## uniq
#define UNIQ __COUNTER__

#define ASSERT_PTR(expr) _ASSERT_PTR(expr, UNIQ_T(_expr_, UNIQ))
#define _ASSERT_PTR(expr, var)             \
        ({                                 \
                typeof(expr) var = (expr); \
                assert(var);               \
                var;                       \
        })

#define COMMAND_TIMEOUT_MSEC (30 * 1000)

static bool unichar_is_valid(char32_t ch) {

        if (ch >= 0x110000) /* End of unicode space */
                return false;
        if ((ch & 0xFFFFF800) == 0xD800) /* Reserved area for UTF-16 */
                return false;
        if ((ch >= 0xFDD0) && (ch <= 0xFDEF)) /* Reserved */
                return false;
        if ((ch & 0xFFFE) == 0xFFFE) /* BOM (Byte Order Mark) */
                return false;

        return true;
}

/* count of characters used to encode one unicode char */
static size_t utf8_encoded_expected_len(uint8_t c) {
        if (c < 0x80)
                return 1;
        if ((c & 0xe0) == 0xc0)
                return 2;
        if ((c & 0xf0) == 0xe0)
                return 3;
        if ((c & 0xf8) == 0xf0)
                return 4;
        if ((c & 0xfc) == 0xf8)
                return 5;
        if ((c & 0xfe) == 0xfc)
                return 6;

        return 0;
}

/* decode one unicode char */
static int utf8_encoded_to_unichar(const char *str, char32_t *ret_unichar) {
        char32_t unichar;
        size_t len;

        assert(str);

        len = utf8_encoded_expected_len(str[0]);

        switch (len) {
        case 1:
                *ret_unichar = (char32_t)str[0];
                return 1;
        case 2:
                unichar = str[0] & 0x1f;
                break;
        case 3:
                unichar = (char32_t)str[0] & 0x0f;
                break;
        case 4:
                unichar = (char32_t)str[0] & 0x07;
                break;
        case 5:
                unichar = (char32_t)str[0] & 0x03;
                break;
        case 6:
                unichar = (char32_t)str[0] & 0x01;
                break;
        default:
                return -EINVAL;
        }

        for (size_t i = 1; i < len; i++) {
                if (((char32_t)str[i] & 0xc0) != 0x80)
                        return -EINVAL;

                unichar <<= 6;
                unichar |= (char32_t)str[i] & 0x3f;
        }

        *ret_unichar = unichar;
        return len;
}

/* expected size used to encode one unicode char */
static int utf8_unichar_to_encoded_len(char32_t unichar) {

        if (unichar < 0x80)
                return 1;
        if (unichar < 0x800)
                return 2;
        if (unichar < 0x10000)
                return 3;
        if (unichar < 0x200000)
                return 4;
        if (unichar < 0x4000000)
                return 5;

        return 6;
}

/* validate one encoded unicode char and return its length */
static int utf8_encoded_valid_unichar(const char *str, size_t length /* bytes */) {
        char32_t unichar;
        size_t len;
        int r;

        assert(str);
        assert(length > 0);

        /* We read until NUL, at most length bytes. SIZE_MAX may be used to disable the length check. */

        len = utf8_encoded_expected_len(str[0]);
        if (len == 0)
                return -EINVAL;

        /* Do we have a truncated multi-byte character? */
        if (len > length)
                return -EINVAL;

        /* ascii is valid */
        if (len == 1)
                return 1;

        /* check if expected encoded chars are available */
        for (size_t i = 0; i < len; i++)
                if ((str[i] & 0x80) != 0x80)
                        return -EINVAL;

        r = utf8_encoded_to_unichar(str, &unichar);
        if (r < 0)
                return r;

        /* check if encoded length matches encoded value */
        if (utf8_unichar_to_encoded_len(unichar) != (int) len)
                return -EINVAL;

        /* check if value has valid range */
        if (!unichar_is_valid(unichar))
                return -EINVAL;

        return (int) len;
}

static int allow_listed_char_for_devnode(char c, const char *additional) {
        return
                (c >= '0' && c <= '9') ||
                (c >= 'A' && c <= 'Z') ||
                (c >= 'a' && c <= 'z') ||
                strchr("#+-.:=@_", c) ||
                (additional && strchr(additional, c));
}

static int encode_devnode_name(const char *str, char *str_enc, size_t len) {
        size_t i, j;

        if (!str || !str_enc)
                return -EINVAL;

        for (i = 0, j = 0; str[i] != '\0'; i++) {
                int seqlen;

                seqlen = utf8_encoded_valid_unichar(str + i, SIZE_MAX);
                if (seqlen > 1) {

                        if (len-j < (size_t) seqlen)
                                return -EINVAL;

                        memcpy(&str_enc[j], &str[i], seqlen);
                        j += seqlen;
                        i += (seqlen-1);

                } else if (str[i] == '\\' || !allow_listed_char_for_devnode(str[i], NULL)) {

                        if (len-j < 4)
                                return -EINVAL;

                        sprintf(&str_enc[j], "\\x%02x", (unsigned char) str[i]);
                        j += 4;

                } else {
                        if (len-j < 1)
                                return -EINVAL;

                        str_enc[j] = str[i];
                        j++;
                }
        }

        if (len-j < 1)
                return -EINVAL;

        str_enc[j] = '\0';
        return 0;
}

static size_t replace_whitespace(const char *str, char *to, size_t len) {
        bool is_space = false;
        size_t i, j;

        assert(str);
        assert(to);

        /* Copy from 'str' to 'to', while removing all leading and trailing whitespace, and replacing
         * each run of consecutive whitespace with a single underscore. The chars from 'str' are copied
         * up to the \0 at the end of the string, or at most 'len' chars.  This appends \0 to 'to', at
         * the end of the copied characters.
         *
         * If 'len' chars are copied into 'to', the final \0 is placed at len+1 (i.e. 'to[len] = \0'),
         * so the 'to' buffer must have at least len+1 chars available.
         *
         * Note this may be called with 'str' == 'to', i.e. to replace whitespace in-place in a buffer.
         * This function can handle that situation.
         *
         * Note that only 'len' characters are read from 'str'. */

        i = strspn(str, " \t\n\r");

        for (j = 0; j < len && i < len && str[i] != '\0'; i++) {
                if (isspace(str[i])) {
                        is_space = true;
                        continue;
                }

                if (is_space) {
                        if (j + 1 >= len)
                                break;

                        to[j++] = '_';
                        is_space = false;
                }
                to[j++] = str[i];
        }

        to[j] = '\0';
        return j;
}

static size_t replace_chars(char *str, const char *allow) {
        size_t i = 0, replaced = 0;

        assert(str);

        /* allow chars in allow list, plain ascii, hex-escaping and valid utf8. */

        while (str[i] != '\0') {
                int len;

                if (allow_listed_char_for_devnode(str[i], allow)) {
                        i++;
                        continue;
                }

                /* accept hex encoding */
                if (str[i] == '\\' && str[i+1] == 'x') {
                        i += 2;
                        continue;
                }

                /* accept valid utf8 */
                len = utf8_encoded_valid_unichar(str + i, SIZE_MAX);
                if (len > 1) {
                        i += len;
                        continue;
                }

                /* if space is allowed, replace whitespace with ordinary space */
                if (isspace(str[i]) && allow && strchr(allow, ' ')) {
                        str[i] = ' ';
                        i++;
                        replaced++;
                        continue;
                }

                /* everything else is replaced with '_' */
                str[i] = '_';
                i++;
                replaced++;
        }
        return replaced;
}

static inline void unaligned_write_ne16(void *_u, uint16_t a) {
        struct __attribute__((__packed__, __may_alias__)) { uint16_t x; } *u = _u;

        u->x = a;
}

static inline uint16_t unaligned_read_le16(const void *_u) {
        const struct __attribute__((__packed__, __may_alias__)) { uint16_t x; } *u = _u;

        return le16toh(u->x);
}

static bool arg_export = false;
static const char *arg_device = NULL;

static int disk_scsi_inquiry_command(
                int fd,
                void *buf,
                size_t buf_len) {

        uint8_t cdb[6] = {
                /* INQUIRY, see SPC-4 section 6.4 */
                [0] = 0x12,                /* OPERATION CODE: INQUIRY */
                [3] = (buf_len >> 8),      /* ALLOCATION LENGTH */
                [4] = (buf_len & 0xff),
        };
        uint8_t sense[32] = {};
        struct sg_io_v4 io_v4 = {
                .guard = 'Q',
                .protocol = BSG_PROTOCOL_SCSI,
                .subprotocol = BSG_SUB_PROTOCOL_SCSI_CMD,
                .request_len = sizeof(cdb),
                .request = (uintptr_t) cdb,
                .max_response_len = sizeof(sense),
                .response = (uintptr_t) sense,
                .din_xfer_len = buf_len,
                .din_xferp = (uintptr_t) buf,
                .timeout = COMMAND_TIMEOUT_MSEC,
        };

        if (ioctl(fd, SG_IO, &io_v4) != 0) {
                if (errno != EINVAL) {
                        dprintf(2, "ioctl v4 failed: %m\n");
                        return -errno;
                }

                /* could be that the driver doesn't do version 4, try version 3 */
                struct sg_io_hdr io_hdr = {
                        .interface_id = 'S',
                        .cmdp = (unsigned char*) cdb,
                        .cmd_len = sizeof (cdb),
                        .dxferp = buf,
                        .dxfer_len = buf_len,
                        .sbp = sense,
                        .mx_sb_len = sizeof(sense),
                        .dxfer_direction = SG_DXFER_FROM_DEV,
                        .timeout = COMMAND_TIMEOUT_MSEC,
                };

                if (ioctl(fd, SG_IO, &io_hdr) != 0) {
                        dprintf(2, "ioctl v3 failed: %m\n");
                        return -errno;
                }

                /* even if the ioctl succeeds, we need to check the return value */
                if (io_hdr.status != 0 ||
                    io_hdr.host_status != 0 ||
                    io_hdr.driver_status != 0) {
                        dprintf(2, "ioctl v3 failed\n");
                        return -EIO;
                }

        } else {
                /* even if the ioctl succeeds, we need to check the return value */
                if (io_v4.device_status != 0 ||
                    io_v4.transport_status != 0 ||
                    io_v4.driver_status != 0) {
                        dprintf(2, "ioctl v4 failed\n");
                        return -EIO;
                }
        }

        return 0;
}

static int disk_identify_command(
                int fd,
                void *buf,
                size_t buf_len) {

        uint8_t cdb[12] = {
                /*
                 * ATA Pass-Through 12 byte command, as described in
                 *
                 *  T10 04-262r8 ATA Command Pass-Through
                 *
                 * from http://www.t10.org/ftp/t10/document.04/04-262r8.pdf
                 */
                [0] = 0xa1,     /* OPERATION CODE: 12 byte pass through */
                [1] = 4 << 1,   /* PROTOCOL: PIO Data-in */
                [2] = 0x2e,     /* OFF_LINE=0, CK_COND=1, T_DIR=1, BYT_BLOK=1, T_LENGTH=2 */
                [3] = 0,        /* FEATURES */
                [4] = 1,        /* SECTORS */
                [5] = 0,        /* LBA LOW */
                [6] = 0,        /* LBA MID */
                [7] = 0,        /* LBA HIGH */
                [8] = 0 & 0x4F, /* SELECT */
                [9] = 0xEC,     /* Command: ATA IDENTIFY DEVICE */
        };
        uint8_t sense[32] = {};
        uint8_t *desc = sense + 8;
        struct sg_io_v4 io_v4 = {
                .guard = 'Q',
                .protocol = BSG_PROTOCOL_SCSI,
                .subprotocol = BSG_SUB_PROTOCOL_SCSI_CMD,
                .request_len = sizeof(cdb),
                .request = (uintptr_t) cdb,
                .max_response_len = sizeof(sense),
                .response = (uintptr_t) sense,
                .din_xfer_len = buf_len,
                .din_xferp = (uintptr_t) buf,
                .timeout = COMMAND_TIMEOUT_MSEC,
        };

        if (ioctl(fd, SG_IO, &io_v4) != 0) {
                if (errno != EINVAL) {
                        dprintf(2, "ioctl v4 failed: %m\n");
                        return -errno;
                }

                /* could be that the driver doesn't do version 4, try version 3 */
                struct sg_io_hdr io_hdr = {
                        .interface_id = 'S',
                        .cmdp = (unsigned char*) cdb,
                        .cmd_len = sizeof (cdb),
                        .dxferp = buf,
                        .dxfer_len = buf_len,
                        .sbp = sense,
                        .mx_sb_len = sizeof (sense),
                        .dxfer_direction = SG_DXFER_FROM_DEV,
                        .timeout = COMMAND_TIMEOUT_MSEC,
                };

                if (ioctl(fd, SG_IO, &io_hdr) != 0) {
                        dprintf(2, "ioctl v3 failed: %m\n");
                        return -errno;
                }
        } else {
                if (!((sense[0] & 0x7f) == 0x72 && desc[0] == 0x9 && desc[1] == 0x0c) &&
                    !((sense[0] & 0x7f) == 0x70 && sense[12] == 0x00 && sense[13] == 0x1d)) {
                        dprintf(2, "ioctl v4 failed: %m\n");
                        return -EIO;
                }
        }

        return 0;
}

static int disk_identify_packet_device_command(
                int fd,
                void *buf,
                size_t buf_len) {

        uint8_t cdb[16] = {
                /*
                 * ATA Pass-Through 16 byte command, as described in
                 *
                 *  T10 04-262r8 ATA Command Pass-Through
                 *
                 * from http://www.t10.org/ftp/t10/document.04/04-262r8.pdf
                 */
                [0] = 0x85,   /* OPERATION CODE: 16 byte pass through */
                [1] = 4 << 1, /* PROTOCOL: PIO Data-in */
                [2] = 0x2e,   /* OFF_LINE=0, CK_COND=1, T_DIR=1, BYT_BLOK=1, T_LENGTH=2 */
                [3] = 0,      /* FEATURES */
                [4] = 0,      /* FEATURES */
                [5] = 0,      /* SECTORS */
                [6] = 1,      /* SECTORS */
                [7] = 0,      /* LBA LOW */
                [8] = 0,      /* LBA LOW */
                [9] = 0,      /* LBA MID */
                [10] = 0,     /* LBA MID */
                [11] = 0,     /* LBA HIGH */
                [12] = 0,     /* LBA HIGH */
                [13] = 0,     /* DEVICE */
                [14] = 0xA1,  /* Command: ATA IDENTIFY PACKET DEVICE */
                [15] = 0,     /* CONTROL */
        };
        uint8_t sense[32] = {};
        uint8_t *desc = sense + 8;
        struct sg_io_v4 io_v4 = {
                .guard = 'Q',
                .protocol = BSG_PROTOCOL_SCSI,
                .subprotocol = BSG_SUB_PROTOCOL_SCSI_CMD,
                .request_len = sizeof (cdb),
                .request = (uintptr_t) cdb,
                .max_response_len = sizeof (sense),
                .response = (uintptr_t) sense,
                .din_xfer_len = buf_len,
                .din_xferp = (uintptr_t) buf,
                .timeout = COMMAND_TIMEOUT_MSEC,
        };

        if (ioctl(fd, SG_IO, &io_v4) != 0) {
                if (errno != EINVAL) {
                        dprintf(2, "ioctl v4 failed: %m\n");
                        return -errno;
                }

                /* could be that the driver doesn't do version 4, try version 3 */
                struct sg_io_hdr io_hdr = {
                        .interface_id = 'S',
                        .cmdp = (unsigned char*) cdb,
                        .cmd_len = sizeof (cdb),
                        .dxferp = buf,
                        .dxfer_len = buf_len,
                        .sbp = sense,
                        .mx_sb_len = sizeof (sense),
                        .dxfer_direction = SG_DXFER_FROM_DEV,
                        .timeout = COMMAND_TIMEOUT_MSEC,
                };

                if (ioctl(fd, SG_IO, &io_hdr) != 0) {
                        dprintf(2, "ioctl v3 failed: %m\n");
                        return -errno;
                }
        } else {
                if ((sense[0] & 0x7f) != 0x72 || desc[0] != 0x9 || desc[1] != 0x0c) {
                        dprintf(2, "ioctl v4 failed: %m\n");
                        return -EIO;
                }
        }

        return 0;
}

/**
 * disk_identify_get_string:
 * @identify: A block of IDENTIFY data
 * @offset_words: Offset of the string to get, in words.
 * @dest: Destination buffer for the string.
 * @dest_len: Length of destination buffer, in bytes.
 *
 * Copies the ATA string from @identify located at @offset_words into @dest.
 */
static void disk_identify_get_string(
                uint8_t identify[512],
                unsigned offset_words,
                char *dest,
                size_t dest_len) {

        unsigned c1;
        unsigned c2;

        while (dest_len > 0) {
                c1 = identify[offset_words * 2 + 1];
                c2 = identify[offset_words * 2];
                *dest = c1;
                dest++;
                *dest = c2;
                dest++;
                offset_words++;
                dest_len -= 2;
        }
}

static void disk_identify_fixup_string(
                uint8_t identify[512],
                unsigned offset_words,
                size_t len) {
        assert(offset_words < 512/2);
        disk_identify_get_string(identify, offset_words,
                                 (char *) identify + offset_words * 2, len);
}

static void disk_identify_fixup_uint16(uint8_t identify[512], unsigned offset_words) {
        assert(offset_words < 512/2);
        unaligned_write_ne16(identify + offset_words * 2,
                             unaligned_read_le16(identify + offset_words * 2));
}

/**
 * disk_identify:
 * @fd: File descriptor for the block device.
 * @out_identify: Return location for IDENTIFY data.
 *
 * Sends the IDENTIFY DEVICE or IDENTIFY PACKET DEVICE command to the
 * device represented by @fd. If successful, then the result will be
 * copied into @out_identify.
 *
 * This routine is based on code from libatasmart, LGPL v2.1.
 *
 * Returns: 0 if the data was successfully obtained, otherwise
 * non-zero with errno set.
 */
static int disk_identify(int fd,
                         uint8_t out_identify[512],
                         int *ret_peripheral_device_type) {
        uint8_t inquiry_buf[36];
        int peripheral_device_type, r;

        /* init results */
        memset(out_identify, 0, 512);

        /* If we were to use ATA PASS_THROUGH (12) on an ATAPI device
         * we could accidentally blank media. This is because MMC's BLANK
         * command has the same op-code (0x61).
         *
         * To prevent this from happening we bail out if the device
         * isn't a Direct Access Block Device, e.g. SCSI type 0x00
         * (CD/DVD devices are type 0x05). So we send a SCSI INQUIRY
         * command first... libata is handling this via its SCSI
         * emulation layer.
         *
         * This also ensures that we're actually dealing with a device
         * that understands SCSI commands.
         *
         * (Yes, it is a bit perverse that we're tunneling the ATA
         * command through SCSI and relying on the ATA driver
         * emulating SCSI well-enough...)
         *
         * (See commit 160b069c25690bfb0c785994c7c3710289179107 for
         * the original bug-fix and see http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=556635
         * for the original bug-report.)
         */
        r = disk_scsi_inquiry_command(fd, inquiry_buf, sizeof inquiry_buf);
        if (r < 0)
                return r;

        /* SPC-4, section 6.4.2: Standard INQUIRY data */
        peripheral_device_type = inquiry_buf[0] & 0x1f;
        if (peripheral_device_type == 0x05) {
                r = disk_identify_packet_device_command(fd, out_identify, 512);
                if (r < 0)
                        return r;
        } else {
                if (peripheral_device_type != 0x00 && peripheral_device_type != 0x14) {
                        dprintf(2, "Unsupported device type.\n");
                        return -EIO;
                }

                /* OK, now issue the IDENTIFY DEVICE command */
                r = disk_identify_command(fd, out_identify, 512);
                if (r < 0)
                        return r;
        }

         /* Check if IDENTIFY data is all NUL bytes - if so, bail */
        bool all_nul_bytes = true;
        for (size_t n = 0; n < 512; n++)
                if (out_identify[n] != '\0') {
                        all_nul_bytes = false;
                        break;
                }

        if (all_nul_bytes) {
                dprintf(2, "IDENTIFY data is all zeroes.\n");
                return -EIO;
        }

        if (ret_peripheral_device_type)
                *ret_peripheral_device_type = peripheral_device_type;

        return 0;
}

static int parse_argv(int argc, char *argv[]) {
        static const struct option options[] = {
                { "export", no_argument, NULL, 'x' },
                { "help",   no_argument, NULL, 'h' },
                {}
        };
        int c;

        while ((c = getopt_long(argc, argv, "xh", options, NULL)) >= 0)
                switch (c) {
                case 'x':
                        arg_export = true;
                        break;
                case 'h':
                        printf("%s [OPTIONS...] DEVICE\n\n"
                               "  -x --export    Print values as environment keys\n"
                               "  -h --help      Show this help text\n",
                               argv[0]);
                        return 0;
                case '?':
                        return -EINVAL;
                default:
                        return -ENOTRECOVERABLE;
                }

        if (!argv[optind]) {
                dprintf(2, "DEVICE argument missing.\n");
                return -EINVAL;
        }

        arg_device = argv[optind];
        return 1;
}

int main(int argc, char *argv[]) {
        struct hd_driveid id;
        union {
                uint8_t  byte[512];
                uint16_t wyde[256];
        } identify;
        char model[41], model_enc[256], serial[21], revision[9];
        int fd = -EBADF;
        uint16_t word;
        int r, peripheral_device_type = -1;

        r = parse_argv(argc, argv);
        if (r <= 0)
                return r < 0 ? 1 : 0;

        fd = open(ASSERT_PTR(arg_device), O_RDONLY|O_NONBLOCK|O_CLOEXEC|O_NOCTTY);
        if (fd < 0) {
                dprintf(2, "Cannot open %s: %m\n", arg_device);
                return 1;
        } else if (fd < 3) {
                /* Not connected to one or more standard streams */
                close(fd);
                return 1;
        }

        if (disk_identify(fd, identify.byte, &peripheral_device_type) >= 0) {
                /*
                 * fix up only the fields from the IDENTIFY data that we are going to
                 * use and copy it into the hd_driveid struct for convenience
                 */
                disk_identify_fixup_string(identify.byte,  10, 20); /* serial */
                disk_identify_fixup_string(identify.byte,  23,  8); /* fwrev */
                disk_identify_fixup_string(identify.byte,  27, 40); /* model */
                disk_identify_fixup_uint16(identify.byte,  0);      /* configuration */
                disk_identify_fixup_uint16(identify.byte,  75);     /* queue depth */
                disk_identify_fixup_uint16(identify.byte,  76);     /* SATA capabilities */
                disk_identify_fixup_uint16(identify.byte,  82);     /* command set supported */
                disk_identify_fixup_uint16(identify.byte,  83);     /* command set supported */
                disk_identify_fixup_uint16(identify.byte,  84);     /* command set supported */
                disk_identify_fixup_uint16(identify.byte,  85);     /* command set supported */
                disk_identify_fixup_uint16(identify.byte,  86);     /* command set supported */
                disk_identify_fixup_uint16(identify.byte,  87);     /* command set supported */
                disk_identify_fixup_uint16(identify.byte,  89);     /* time required for SECURITY ERASE UNIT */
                disk_identify_fixup_uint16(identify.byte,  90);     /* time required for enhanced SECURITY ERASE UNIT */
                disk_identify_fixup_uint16(identify.byte,  91);     /* current APM values */
                disk_identify_fixup_uint16(identify.byte,  94);     /* current AAM value */
                disk_identify_fixup_uint16(identify.byte, 108);     /* WWN */
                disk_identify_fixup_uint16(identify.byte, 109);     /* WWN */
                disk_identify_fixup_uint16(identify.byte, 110);     /* WWN */
                disk_identify_fixup_uint16(identify.byte, 111);     /* WWN */
                disk_identify_fixup_uint16(identify.byte, 128);     /* device lock function */
                disk_identify_fixup_uint16(identify.byte, 217);     /* nominal media rotation rate */
                memcpy(&id, identify.byte, sizeof id);
        } else {
                /* If this fails, then try HDIO_GET_IDENTITY */
                if (ioctl(fd, HDIO_GET_IDENTITY, &id) != 0) {
                        dprintf(2, "%s: HDIO_GET_IDENTITY failed: %m\n", arg_device);
                        close(fd);
                        return 2;
                }
        }

        close(fd);

        memcpy(model, id.model, 40);
        model[40] = '\0';
        encode_devnode_name(model, model_enc, sizeof(model_enc));
        replace_whitespace((char *) id.model, model, 40);
        replace_chars(model, NULL);
        replace_whitespace((char *) id.serial_no, serial, 20);
        replace_chars(serial, NULL);
        replace_whitespace((char *) id.fw_rev, revision, 8);
        replace_chars(revision, NULL);

        if (arg_export) {
                /* Set this to convey the disk speaks the ATA protocol */
                printf("ID_ATA=1\n");

                if ((id.config >> 8) & 0x80) {
                        /* This is an ATAPI device */
                        switch ((id.config >> 8) & 0x1f) {
                        case 0:
                                printf("ID_TYPE=cd\n");
                                break;
                        case 1:
                                printf("ID_TYPE=tape\n");
                                break;
                        case 5:
                                printf("ID_TYPE=cd\n");
                                break;
                        case 7:
                                printf("ID_TYPE=optical\n");
                                break;
                        default:
                                printf("ID_TYPE=generic\n");
                                break;
                        }
                } else
                        printf("ID_TYPE=disk\n");
                printf("ID_BUS=ata\n");
                printf("ID_MODEL=%s\n", model);
                printf("ID_MODEL_ENC=%s\n", model_enc);
                printf("ID_REVISION=%s\n", revision);
                if (serial[0] != '\0') {
                        printf("ID_SERIAL=%s_%s\n", model, serial);
                        printf("ID_SERIAL_SHORT=%s\n", serial);
                } else
                        printf("ID_SERIAL=%s\n", model);

                if (id.command_set_1 & (1<<5)) {
                        printf("ID_ATA_WRITE_CACHE=1\n");
                        printf("ID_ATA_WRITE_CACHE_ENABLED=%d\n", (id.cfs_enable_1 & (1<<5)) ? 1 : 0);
                }
                if (id.command_set_1 & (1<<10)) {
                        printf("ID_ATA_FEATURE_SET_HPA=1\n");
                        printf("ID_ATA_FEATURE_SET_HPA_ENABLED=%d\n", (id.cfs_enable_1 & (1<<10)) ? 1 : 0);

                        /*
                         * TODO: use the READ NATIVE MAX ADDRESS command to get the native max address
                         * so it is easy to check whether the protected area is in use.
                         */
                }
                if (id.command_set_1 & (1<<3)) {
                        printf("ID_ATA_FEATURE_SET_PM=1\n");
                        printf("ID_ATA_FEATURE_SET_PM_ENABLED=%d\n", (id.cfs_enable_1 & (1<<3)) ? 1 : 0);
                }
                if (id.command_set_1 & (1<<1)) {
                        printf("ID_ATA_FEATURE_SET_SECURITY=1\n");
                        printf("ID_ATA_FEATURE_SET_SECURITY_ENABLED=%d\n", (id.cfs_enable_1 & (1<<1)) ? 1 : 0);
                        printf("ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=%d\n", id.trseuc * 2);
                        if ((id.cfs_enable_1 & (1<<1))) /* enabled */ {
                                if (id.dlf & (1<<8))
                                        printf("ID_ATA_FEATURE_SET_SECURITY_LEVEL=maximum\n");
                                else
                                        printf("ID_ATA_FEATURE_SET_SECURITY_LEVEL=high\n");
                        }
                        if (id.dlf & (1<<5))
                                printf("ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=%d\n", id.trsEuc * 2);
                        if (id.dlf & (1<<4))
                                printf("ID_ATA_FEATURE_SET_SECURITY_EXPIRE=1\n");
                        if (id.dlf & (1<<3))
                                printf("ID_ATA_FEATURE_SET_SECURITY_FROZEN=1\n");
                        if (id.dlf & (1<<2))
                                printf("ID_ATA_FEATURE_SET_SECURITY_LOCKED=1\n");
                }
                if (id.command_set_1 & (1<<0)) {
                        printf("ID_ATA_FEATURE_SET_SMART=1\n");
                        printf("ID_ATA_FEATURE_SET_SMART_ENABLED=%d\n", (id.cfs_enable_1 & (1<<0)) ? 1 : 0);
                }
                if (id.command_set_2 & (1<<9)) {
                        printf("ID_ATA_FEATURE_SET_AAM=1\n");
                        printf("ID_ATA_FEATURE_SET_AAM_ENABLED=%d\n", (id.cfs_enable_2 & (1<<9)) ? 1 : 0);
                        printf("ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=%d\n", id.acoustic >> 8);
                        printf("ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=%d\n", id.acoustic & 0xff);
                }
                if (id.command_set_2 & (1<<5)) {
                        printf("ID_ATA_FEATURE_SET_PUIS=1\n");
                        printf("ID_ATA_FEATURE_SET_PUIS_ENABLED=%d\n", (id.cfs_enable_2 & (1<<5)) ? 1 : 0);
                }
                if (id.command_set_2 & (1<<3)) {
                        printf("ID_ATA_FEATURE_SET_APM=1\n");
                        printf("ID_ATA_FEATURE_SET_APM_ENABLED=%d\n", (id.cfs_enable_2 & (1<<3)) ? 1 : 0);
                        if ((id.cfs_enable_2 & (1<<3)))
                                printf("ID_ATA_FEATURE_SET_APM_CURRENT_VALUE=%d\n", id.CurAPMvalues & 0xff);
                }
                if (id.command_set_2 & (1<<0))
                        printf("ID_ATA_DOWNLOAD_MICROCODE=1\n");

                /*
                 * Word 76 indicates the capabilities of a SATA device. A PATA device shall set
                 * word 76 to 0000h or FFFFh. If word 76 is set to 0000h or FFFFh, then
                 * the device does not claim compliance with the Serial ATA specification and words
                 * 76 through 79 are not valid and shall be ignored.
                 */

                word = identify.wyde[76];
                if (word != 0x0000 && word != 0xffff) {
                        printf("ID_ATA_SATA=1\n");
                        /*
                         * If bit 2 of word 76 is set to one, then the device supports the Gen2
                         * signaling rate of 3.0 Gb/s (see SATA 2.6).
                         *
                         * If bit 1 of word 76 is set to one, then the device supports the Gen1
                         * signaling rate of 1.5 Gb/s (see SATA 2.6).
                         */
                        if (word & (1<<2))
                                printf("ID_ATA_SATA_SIGNAL_RATE_GEN2=1\n");
                        if (word & (1<<1))
                                printf("ID_ATA_SATA_SIGNAL_RATE_GEN1=1\n");
                }

                /* Word 217 indicates the nominal media rotation rate of the device */
                word = identify.wyde[217];
                if (word == 0x0001)
                        printf ("ID_ATA_ROTATION_RATE_RPM=0\n"); /* non-rotating e.g. SSD */
                else if (word >= 0x0401 && word <= 0xfffe)
                        printf ("ID_ATA_ROTATION_RATE_RPM=%d\n", word);

                /*
                 * Words 108-111 contain a mandatory World Wide Name (WWN) in the NAA IEEE Registered identifier
                 * format. Word 108 bits (15:12) shall contain 5h, indicating that the naming authority is IEEE.
                 * All other values are reserved.
                 */
                word = identify.wyde[108];
                if ((word & 0xf000) == 0x5000) {
                        uint64_t wwwn;

                        wwwn   = identify.wyde[108];
                        wwwn <<= 16;
                        wwwn  |= identify.wyde[109];
                        wwwn <<= 16;
                        wwwn  |= identify.wyde[110];
                        wwwn <<= 16;
                        wwwn  |= identify.wyde[111];
                        printf("ID_WWN=0x%1$" PRIx64 "\n"
                               "ID_WWN_WITH_EXTENSION=0x%1$" PRIx64 "\n",
                               wwwn);
                }

                /* from Linux's include/linux/ata.h */
                if (identify.wyde[0] == 0x848a || identify.wyde[0] == 0x844a ||
                    (identify.wyde[83] & 0xc004) == 0x4004)
                        printf("ID_ATA_CFA=1\n");

                if (peripheral_device_type >= 0)
                        printf("ID_ATA_PERIPHERAL_DEVICE_TYPE=%d\n", peripheral_device_type);
        } else {
                if (serial[0] != '\0')
                        printf("%s_%s\n", model, serial);
                else
                        printf("%s\n", model);
        }

        return 0;
}
