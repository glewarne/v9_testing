#!/system/bin/sh

# Galaxy S6 Lollipop 5.1.1 Post-Init ramdisk script
# By g.lewarne @ xda

# Parse Mode Enforcement from prop
if [ "`grep "kernel.turbo=true" /system/unikernel.prop`" != "" ]; then
	echo "1" > /sys/devices/system/cpu/cpu0/cpufreq/interactive/enforced_mode
	echo "1" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/enforced_mode
fi

# Wait for 5 second so we pass out of init before starting the rest of the script
sleep 5

# Start SuperSU daemon
/system/xbin/daemonsu --auto-daemon &

# Parse Interactive tuning from prop
if [ "`grep "kernel.interactive=performance" /system/unikernel.prop`" != "" ]; then
	# apollo	
	echo "12000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
	echo "45000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
	echo "80"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
	echo "1"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
	echo "70"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
	echo "35000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
	echo "20000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
	# atlas
	echo "25000 1300000:20000 1700000:20000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
	echo "45000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
	echo "83"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
	echo "1"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
	echo "60 1500000:70"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
	echo "35000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
	echo "15000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
elif [ "`grep "kernel.interactive=battery" /system/unikernel.prop`" != "" ]; then
	# apollo	
	echo "37000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/above_hispeed_delay
	echo "25000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/boostpulse_duration
	echo "80"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/go_hispeed_load
	echo "0"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/io_is_busy
	echo "90"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/target_loads
	echo "15000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/min_sample_time
	echo "15000"	> /sys/devices/system/cpu/cpu0/cpufreq/interactive/timer_rate
	# atlas
	echo "70000 1300000:55000 1700000:55000" > /sys/devices/system/cpu/cpu4/cpufreq/interactive/above_hispeed_delay
	echo "25000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/boostpulse_duration
	echo "95"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/go_hispeed_load
	echo "0"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/io_is_busy
	echo "80 1500000:90"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/target_loads
	echo "15000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/min_sample_time
	echo "15000"	> /sys/devices/system/cpu/cpu4/cpufreq/interactive/timer_rate
fi

sleep 5
# Parse IO Scheduler from prop
if [ "`grep "kernel.scheduler=noop" /system/unikernel.prop`" != "" ]; then
	echo "noop" > /sys/block/mmcblk0/queue/scheduler
    	echo "noop" > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=fiops" /system/unikernel.prop`" != "" ]; then
	echo "fiops" > /sys/block/mmcblk0/queue/scheduler
    	echo "fiops" > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=bfq" /system/unikernel.prop`" != "" ]; then
	echo "bfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "bfq" > /sys/block/sda/queue/scheduler
elif [ "`grep "kernel.scheduler=deadline" /system/unikernel.prop`" != "" ]; then
	echo "deadline" > /sys/block/mmcblk0/queue/scheduler
    	echo "deadline" > /sys/block/sda/queue/scheduler
else
	echo "cfq" > /sys/block/mmcblk0/queue/scheduler
    	echo "cfq" > /sys/block/sda/queue/scheduler
fi

# Parse VM Tuning from prop
if [ "`grep "kernel.vm=tuned" /system/unikernel.prop`" != "" ]; then
	echo "200"	> /proc/sys/vm/vfs_cache_pressure
	echo "400"	> /proc/sys/vm/dirty_expire_centisecs
	echo "400"	> /proc/sys/vm/dirty_writeback_centisecs
	echo "145"	> /proc/sys/vm/swappiness
	echo "64"	> /sys/block/sda/queue/read_ahead_kb
	echo "64"	> /sys/block/sdb/queue/read_ahead_kb
	echo "64"	> /sys/block/sdb/queue/read_ahead_kb
	echo "64"	> /sys/block/vnswap0/queue/read_ahead_kb
fi

# Parse GApps wakelock fix from prop
if [ "`grep "kernel.gapps=true" /system/unikernel.prop`" != "" ]; then
	sleep 60
	su -c "pm enable com.google.android.gms/.update.SystemUpdateActivity"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$ActiveReceiver"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$Receiver"
	su -c "pm enable com.google.android.gms/.update.SystemUpdateService$SecretCodeReceiver"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateActivity"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdatePanoActivity"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateService"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$Receiver"
	su -c "pm enable com.google.android.gsf/.update.SystemUpdateService$SecretCodeReceiver"
fi

