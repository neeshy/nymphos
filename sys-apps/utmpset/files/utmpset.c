#include <fcntl.h>
#include <time.h>
#include <sys/file.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <unistd.h>
#include <utmp.h>
#include <errno.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>

#define USAGE "[-w] line"
#define FATAL "utmpset: fatal: "
#define WARNING "utmpset: warning: "

const char *progname;

void die(int e, const char *fmt, ...) {
  va_list ap;
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);

  fprintf(stderr, "\n");
  fflush(stderr);

  _exit(e);
}

void diesys(int e, const char *fmt, ...) {
  int err = errno;

  va_list ap;
  va_start(ap, fmt);
  vfprintf(stderr, fmt, ap);
  va_end(ap);

  fprintf(stderr, ": %s\n", strerror(err));
  fflush(stderr);

  _exit(e);
}

void usage(void) { die(1, "usage: %s " USAGE, progname); }

int utmp_logout(const char *line) {
  int fd;
  size_t len;
  struct utmp ut;
  time_t t;
  int ok = -1;

  if ((len = strlen(line)) > sizeof(ut.ut_line))
    die(111, FATAL "unable to logout line %s in utmp: name too long", line);
  if (len < sizeof(ut.ut_line)) ++len;
  if ((fd = open(_PATH_UTMP, O_RDWR, 0)) < 0)
    diesys(111, FATAL "unable to open " _PATH_UTMP);
  if (flock(fd, LOCK_EX) == -1)
    diesys(111, FATAL "unable to lock " _PATH_UTMP);

  while (read(fd, &ut, sizeof(struct utmp)) == sizeof(struct utmp)) {
    if (!ut.ut_name[0] || memcmp(ut.ut_line, line, len) != 0) continue;
    memset(ut.ut_name, 0, sizeof(ut.ut_name));
    memset(ut.ut_host, 0, sizeof(ut.ut_host));
    if (time(&t) == -1) break;
    ut.ut_time = t;
    ut.ut_type = DEAD_PROCESS;
    if (lseek(fd, -(off_t)sizeof(struct utmp), SEEK_CUR) == -1) break;
    if (write(fd, &ut, sizeof(struct utmp)) != sizeof(struct utmp)) break;
    ok = 1;
    break;
  }
  close(fd);
  return ok;
}

int wtmp_logout(const char *line) {
  int fd;
  int len;
  struct stat st;
  struct utmp ut;
  time_t t;

  if ((fd = open(_PATH_WTMP, O_WRONLY | O_NDELAY | O_APPEND | O_CREAT, 0600)) == -1)
    diesys(111, FATAL "unable to open " _PATH_WTMP);
  if (flock(fd, LOCK_EX) == -1)
    diesys(111, FATAL "unable to lock " _PATH_WTMP);

  if (fstat(fd, &st) == -1) {
    close(fd);
    return -1;
  }
  memset(&ut, 0, sizeof(struct utmp));
  if ((len = strlen(line)) > sizeof(ut.ut_line)) len = sizeof(ut.ut_line) - 2;
  memcpy(ut.ut_line, line, len);
  if (time(&t) == -1) {
    close(fd);
    return -1;
  }
  ut.ut_time = t;
  ut.ut_type = DEAD_PROCESS;
  if (write(fd, &ut, sizeof(struct utmp)) != sizeof(struct utmp)) {
    ftruncate(fd, st.st_size);
    close(fd);
    return -1;
  }
  close(fd);
  return 1;
}

int main(int argc, char *const *argv) {
  int opt;
  int wtmp = 0;

  progname = *argv;

  while ((opt = getopt(argc, argv, "w")) != -1) {
    switch(opt) {
    case 'w':
      wtmp = 1;
      break;
    case '?':
      usage();
    }
  }
  argv += optind;

  if (!argv || !*argv) usage();
  if (utmp_logout(*argv) == -1)
    die(111, WARNING "unable to logout line %s in utmp: no such entry", *argv);
  if (wtmp)
    if (wtmp_logout(*argv) == -1)
      diesys(111, WARNING "unable to logout line %s in wtmp", *argv);
  _exit(0);
}
