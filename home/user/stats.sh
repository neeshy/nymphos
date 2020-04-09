gcc -Ofast -march=native -mfpmath=both -funroll-loops -fgraphite-identity -floop-nest-optimize -malign-data=cacheline -mtls-dialect=gnu2 -o /tmp/stats -xc - <<HEREDOC && exec /tmp/stats
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <dirent.h>
char *getfile(char *filename, char *buffer) {
	FILE *fp;
	if ((fp = fopen(filename, "r"))) {
		int size = fread(buffer, 1, 3000, fp);
		fclose(fp);
		buffer[size] = '\0';
		return buffer;
	} else {
		return 0;
	}
}
void main(void) {
	char buffer[3000], *file;
	int firstrun = 1;
	for (;;) {
		file = getfile("/proc/version", buffer);
		file = file+14;
		*strchr(file, ' ') = '\0';
		char uname[30];
		sprintf(uname, "%s%s", "Linux ", file);

		file = getfile("/proc/uptime", buffer);
		*strchr(file, '.') = '\0';
		int days = atoi(file)/86400;
		int hours = atoi(file)/3600%24;
		int minutes = atoi(file)/60%60;
		char uptime[20];
		if (days > 0) {
			sprintf(uptime, "%dd %dh %dm", days, hours, minutes);
		} else if (hours > 0) {
			sprintf(uptime, "%dh %dm", hours, minutes);
		} else {
			sprintf(uptime, "%dm", minutes);
		}

		int processesi = 0;
		struct dirent *dir;
		DIR *dp = opendir("/proc/");
		while ((dir = readdir(dp)) != NULL) {
			if (dir->d_name[0] >= '0' && dir->d_name[0] <= '9') {
				processesi++;
			}
		}
		closedir(dp);
		char processes[10];
		sprintf(processes, "%d", processesi);

		file = getfile("/proc/stat", buffer);
		file = strstr(file, "procs_running ")+14;
		*strchr(file, '\n') = '\0';
		char active[5];
		strcpy(active, file);

		file = getfile("/proc/stat", buffer);
		*strchr(file, '\n') = '\0';
		file = file+3;
		unsigned long int cputotal, cpuidle, cpulasttotal, cpulastidle;
		cputotal = atol(strtok(file, " "));
		for (int i = 0; i < 2; i++, cputotal += atol(strtok(NULL, " ")));
		cpuidle = atol(strtok(NULL, " "));
		cputotal += cpuidle;
		for (int i = 0; i < 6; i++, cputotal += atol(strtok(NULL, " ")));
		char cpu[5];
		if (!firstrun) {
			sprintf(cpu, "%lu%%", (1000*((cputotal-cpulasttotal)-(cpuidle-cpulastidle))/(cputotal-cpulasttotal)+5)/10);
		} else {
			sprintf(cpu, "0%%");
		}
		cpulasttotal = cputotal;
		cpulastidle = cpuidle;

		file = getfile("/proc/meminfo", buffer);
		char memory[50];
		strncpy(memory, strstr(file, "MemTotal: ")+10, 50); *strstr(memory, " kB") = '\0'; *strrchr(memory, ' ')+1;
		unsigned long int memtotal = atol(memory);
		strncpy(memory, strstr(file, "MemFree: ")+9, 50); *strstr(memory, " kB") = '\0'; *strrchr(memory, ' ')+1;
		unsigned long int memfree = atol(memory);
		strncpy(memory, strstr(file, "Buffers: ")+9, 50); *strstr(memory, " kB") = '\0'; *strrchr(memory, ' ')+1;
		unsigned long int buffers = atol(memory);
		strncpy(memory, strstr(file, "Cached: ")+8, 50); *strstr(memory, " kB") = '\0'; *strrchr(memory, ' ')+1;
		unsigned long int cached = atol(memory);
		strncpy(memory, strstr(file, "Shmem: ")+7, 50); *strstr(memory, " kB") = '\0'; *strrchr(memory, ' ')+1;
		unsigned long int shmem = atol(memory);
		strncpy(memory, strstr(file, "SReclaimable: ")+14, 50); *strstr(memory, " kB") = '\0'; *strrchr(memory, ' ')+1;
		unsigned long int sreclaimable = atol(memory);
		sprintf(memory, "%luMiB %luMiB %.0f%%", (memtotal+shmem-memfree-buffers-cached-sreclaimable)/1024, memtotal/1024, (float)(memtotal+shmem-memfree-buffers-cached-sreclaimable)/memtotal*100);

		file = getfile("/proc/net/dev", buffer);
		file = strchr(file, '\n')+1;
		file = strchr(file, '\n')+1;
		int x;
		for (int i = x = 1; file[i]; ++i) {
			if (file[i] != ' ' || file[i-1] != ' ') {
				file[x++] = file[i];
			}
		}
		file[x] = '\0';
		unsigned long int totalint = 0, totaloutt = 0, totallastint, totallastoutt;
		char *token;
		token = strtok(file, "\n");
		while (token != NULL) {
			token = strchr(token, ':')+1;
			token = token+1;
			char *buf;
			strtok_r(token, " ", &buf);
			totalint += atol(token);
			for (int i = 0; i < 8; i++, token = strtok_r(NULL, " ", &buf));
			totaloutt += atol(token);
			token = strtok(NULL, "\n");
		}
		char totalin[20], totalout[20];
		if (totalint > 1048576) {
			sprintf(totalin, "%luMiB", totalint/1048576);
		} else {
			sprintf(totalin, "0MiB");
		}
		if (totaloutt > 1048576) {
			sprintf(totalout, "%luMiB", totaloutt/1048576);
		} else {
			sprintf(totalout, "0MiB");
		}
		char netin[20], netout[20];
		if (totalint-totallastint > 104857 && !firstrun) {
			sprintf(netin, "%.1fMiB/s", (float)(totalint-totallastint)/1048576/2);
		} else {
			sprintf(netin, "0MiB/s");
		}
		if (totaloutt-totallastoutt > 104857 && !firstrun) {
			sprintf(netout, "%.1fMiB/s", (float)(totaloutt-totallastoutt)/1048576/2);
		} else {
			sprintf(netout, "0MiB/s");
		}
		totallastint = totalint;
		totallastoutt = totaloutt;

		char temperature[40];
		for (int i = 0; i < 5; i++) {
			sprintf(temperature, "%s%d%s", "/sys/class/hwmon/hwmon", i, "/name");
			file = getfile(temperature, buffer);
			if (!file) {
				break;
			}
			*strchr(file, '\n') = '\0';
			if (strcmp(file, "coretemp") == 0 || strcmp(file, "nct6775") == 0 || strncmp(file, "it87", 4) == 0 || strcmp(file, "k8temp") == 0 || strcmp(file, "k9temp") == 0 ) {
				break;
			}
		}
		temperature[strlen(temperature)-4] = '\0';
		strcat(temperature, "temp1_input");
		file = getfile(temperature, buffer);
		if (!file) {
			temperature[strlen(temperature)-11] = '\0';
			strcat(temperature, "temp2_input");
			file = getfile(temperature, buffer);
		}
		if (file) {
			file[strlen(file)-4] = 'C';
			file[strlen(file)-3] = '\0';
			strcpy(temperature, file);
		} else {
			strcpy(temperature, "N/A");
		}

		char volume[50];
		sprintf(buffer, "%ld", (time_t)time(NULL));
		if (atol(buffer)%60 == 0 || firstrun) {
			sprintf(volume, "%s%s%s", "/home/", getenv("USER"), "/.asoundrc");
			file = getfile(volume, buffer);
			if (file) {
				file = strstr(file, "defaults.pcm.card ");
				if (file != NULL) {
					file = file+18;
					*strchr(file, '\n') = '\0';
				}
			}
			if (file) {
				sprintf(volume, "%s%s%s", "/proc/asound/card", file, "/codec#0");
			} else {
				strcpy(volume, "/proc/asound/card0/codec#0");
			}
			file = getfile(volume, buffer);
			if (file) {
				file = strstr(file, "Amp-Out vals:  [0x");
				if (file != NULL) {
					file = file+18;
					*strchr(file, ' ') = '\0';
					sprintf(volume, "%lu%%", strtol(file, NULL, 16));
				} else {
					strcpy(volume, "N/A");
				}
			} else {
				strcpy(volume, "N/A");
			}
		}

		file = getfile("/sys/class/power_supply/AC/online", buffer);
		char ac[2];
		if (file) {
			file[strlen(file)-1] = '\0';
			if (strcmp(file, "1") == 0) {
				ac[0] = 'Y';
			} else {
				ac[0] = 'N';
			}
		} else {
			ac[0] = 'Y';
		}
		ac[1] = '\0';

		file = getfile("/sys/class/power_supply/BAT0/capacity", buffer);
		if (!file) {
			file = getfile("/sys/class/power_supply/BAT1/capacity", buffer);
		}
		char battery[10];
		if (file) {
			*strchr(file, '\n') = '\0';
			strcat(file, "%");
			strcpy(battery, file);
		} else {
			strcpy(battery, "N/A");
		}

		char brightness[5];
		dp = opendir("/sys/class/backlight/");
		if (dp) {
			char brightnessfilename[60];
			char brightnessmaxfilename[60];
			while ((dir = readdir(dp)) != NULL) {
				sprintf(brightnessmaxfilename, "%s%s%s", "/sys/class/backlight/", dir->d_name, "/max_brightness");
				sprintf(brightnessfilename, "%s%s%s", "/sys/class/backlight/", dir->d_name, "/actual_brightness");
			}
			closedir(dp);
			if (strstr(brightnessfilename, "..") == NULL) {
				sprintf(brightness, "%d%s", atoi(getfile(brightnessfilename, buffer))*100/atoi(getfile(brightnessmaxfilename, buffer)), "%");
			} else {
				strcpy(brightness, "N/A");
			}
		} else {
			strcpy(brightness, "N/A");
		}

		file = getfile("/proc/net/wireless", buffer);
		char wifi[5];
		if (file) {
			file = strchr(file, '\n')+1;
			file = strchr(file, '\n')+1;
			if (*file) {
				strtok(file, " ");
				for (int i = 0; i < 2; i++, file = strtok(NULL, " "));
				file[strlen(file)-1] = '\0';
				sprintf(wifi, "%d%%", atoi(file)*100/70);
			} else {
				strcpy(wifi, "N/A");
			}
		} else {
			strcpy(wifi, "N/A");
		}

		time_t rawtime = time(NULL);
		struct tm *info = localtime(&rawtime);
		char date[30];
		strftime(date, 30, "%a %d %b %Y %H:%M:%S %Z", info);

		printf("%s Up: \e[32m%s\e[0m Proc: \e[32m%s\e[0m Active: \e[32m%s\e[0m Cpu: \e[32m%s\e[0m Mem: \e[32m%s\e[0m Net In: \e[32m%s (%s)\e[0m Net Out: \e[32m%s (%s)\e[0m Temp: \e[32m%s\e[0m Vol: \e[32m%s\e[0m AC: \e[32m%s\e[0m Batt: \e[32m%s\e[0m Bright: \e[32m%s\e[0m Wifi: \e[32m%s\e[0m %s             \e[?25l\r", uname, uptime, processes, active, cpu, memory, netin, totalin, netout, totalout, temperature, volume, ac, battery, brightness, wifi, date);
		fflush(stdout);
		firstrun = 0;
		nanosleep((struct timespec[]){{2, 0}}, NULL);
	}
}
HEREDOC
