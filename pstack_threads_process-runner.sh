1.) create script on indexer
vi pstack_threads_process-runner.sh

#!/bin/bash
#usage send job to background: nohup ./pstack_threads_process-runner.sh &
OUTPUT_DIR=/tmp
SPLUNK_HOME=/opt/splunk
mkdir -p $OUTPUT_DIR
SAMPLE_PERIOD=1
while true
do
pid=`head -2 $SPLUNK_HOME/var/run/splunk/splunkd.pid | tail -1`
threads=`cat /proc/$pid/status|grep Threads|awk '{print $2}'`
if [ $threads -gt 0 ]; then
pstack $pid > $OUTPUT_DIR/pstack_splunkd-$pid-$threads-`date +%s`.out
sleep $SAMPLE_PERIOD
fi
sleep $SAMPLE_PERIOD
done


2.) give executable permissions to the file
chmod +x pstack_threads_process-runner.sh


3.) run script manually 
./pstack_threads_process-runner.sh

or run script in the background and keep it running after exiting the terminal session, use the syntax:

nohup ./pstack_threads_process-runner.sh &


you can now exit the terminal session and log back in and confirm the script is still running: 

ps -ef | grep pstack | grep -v color
root      7513 31041  0 19:55 pts/0    00:00:00 /bin/bash ./pstack_threads_process-runner.sh


The script will continue to collect until stopped.


to stop the script:
kill -9 <pid>
