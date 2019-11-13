grep /closeio.html log.txt | egrep -v '127.0.0.1|::1' | sort | awk '{ print $2 }' | uniq -ic | sort -r | while read count ip; do echo ${ip} appeared ${count} times; done
