#include <dirent.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

#ifndef LED_NAME
#define LED_NAME "power"
#endif

#ifndef BATTERY_LEVEL_WARN
#define BATTERY_LEVEL_WARN 15
#endif

#ifndef LED_ON_MS
#define LED_ON_MS 250
#endif

#ifndef LED_OFF_MS
#define LED_OFF_MS 250
#endif

#ifndef LED_ON_MS_WIFI
#define LED_ON_MS_WIFI 100
#endif

#ifndef LED_OFF_MS_WIFI
#define LED_OFF_MS_WIFI 1400
#endif

#ifndef SLEEP_DELAY_S
#define SLEEP_DELAY_S 60
#endif

static int power_online(void)
{
	FILE *f = fopen("/sys/class/power_supply/usb/online", "r");
	if (!f) {
		perror("Unable to open USB sysfs file");
		return -1;
	}

	int online;
	fscanf(f, "%i", &online);
	fclose(f);
	// if (online)
		// return online;

	// f = fopen("/sys/class/power_supply/dc/online", "r");
	// if (!f) {
		// perror("Unable to open USB sysfs file");
		// return -1;
	// }

	// fscanf(f, "%i", &online);
	// fclose(f);
	return online;
}

static int battery_get_level(void)
{
	FILE *f = fopen("/sys/class/power_supply/battery/capacity", "r");
	if (!f)
		return -1;

	int battery_level;
	fscanf(f, "%i", &battery_level);
	fclose(f);
	return battery_level;
}

static int has_wlan_interfaces(void)
{
	struct dirent *d;
	DIR *dir = opendir("/sys/class/net");
	if (!dir) {
		perror("Unable to open /sys/class/net directory");
		return -1;
	}

	while ((d = readdir(dir))) {
		if (!strncmp(d->d_name, "wlan", 4)) {
			char buf[256];
			sprintf(buf, "/sys/class/net/%s/operstate", d->d_name);

			FILE *f = fopen(buf, "r");
			if (!f) {
				perror("Unable to open operstate file");
				continue;
			}

			uint16_t up;
			fread(&up, 2, 1, f);
			fclose(f);

			if (up == 0x7075) {
				closedir(dir);
				return 1;
			}
		}
	}

	closedir(dir);
	return 0;
}

static int led_reset(void)
{
	FILE *r = fopen("/sys/class/leds/" LED_NAME "/max_brightness", "r");
	if (!r)
		return -1;

	char buf[16];
	size_t read = fread(buf, 1, 16, r);
	fclose(r);

	FILE *w = fopen("/sys/class/leds/" LED_NAME "/brightness", "w");
	if (!w)
		return -1;

	fwrite(buf, 1, read, w);
	fclose(w);
	return 0;
}

static int disable_timer(void)
{
	FILE *f = fopen("/sys/class/leds/" LED_NAME "/trigger", "w");
	if (!f)
		return -1;

	fwrite("none", sizeof "none", 1, f);
	fclose(f);
	return 0;
}

static int enable_timer(unsigned int on_ms, unsigned int off_ms)
{
	FILE *f = fopen("/sys/class/leds/" LED_NAME "/trigger", "w");
	if (!f)
		return -1;
	fwrite("timer", sizeof "timer", 1, f);
	fclose(f);

	char buf[16];
	sprintf(buf, "%u", on_ms);
	size_t len = strlen(buf) + 1;

	f = fopen("/sys/class/leds/" LED_NAME "/delay_on", "w");
	if (!f)
		return -1;
	fwrite(buf, len, 1, f);
	fclose(f);

	sprintf(buf, "%u", off_ms);
	len = strlen(buf) + 1;
	f = fopen("/sys/class/leds/" LED_NAME "/delay_off", "w");
	if (!f)
		return -1;
	fwrite(buf, len, 1, f);
	fclose(f);
	return 0;
}

int main(int argc, char **argv)
{
	int timer_enabled = 0;

	while (1) {
		int battery_level = battery_get_level();
		if (battery_level < 0) {
			perror("Unable to open battery sysfs file");
			return 1;
		}

		printf("Battery level: %i\n", battery_level);

		if (power_online()) {
			if (timer_enabled && battery_level > BATTERY_LEVEL_WARN) {
				if (has_wlan_interfaces() > 0) {
					printf("Reverting to the WiFi notifier blinking mode\n");
					enable_timer(LED_ON_MS_WIFI, LED_OFF_MS_WIFI);
				} else {
					printf("Disabling timer\n");
					disable_timer();
					led_reset();
				}
				timer_enabled = 0;
			}
		} else if (!timer_enabled && battery_level < BATTERY_LEVEL_WARN) {
			printf("Enabling timer\n");
			if (enable_timer(LED_ON_MS, LED_OFF_MS)) {
				perror("Unable to open Power LED sysfs file");
				return 1;
			}

			timer_enabled = 1;
		}

		sleep(SLEEP_DELAY_S);
	}

	return 0;
}
