grep -o 'on line [[:digit:]]*' /var/log/nginx/error.log | sort | uniq -c | sort -nr
grep 'on line 513' /var/log/nginx/error.log | head -1 | cut -d' ' -f6-
