#!/bin/sh

UNAME=shopsysbot
UPASS=7B9wHFZVitUqWPkxH7cpMhxf
UTOKEN=ba4bb7f5-bbef-487b-be64-865628dfe067

#TOKEN=$(curl -s -H "Content-Type: application/json" -X POST -d '{"username": "'${UNAME}'", "password": "'${UPASS}'"}' https://hub.docker.com/v2/users/login/ | jq -r .token)
#echo ${TOKEN}
repositoryJson=`curl -L -s 'https://registry.hub.docker.com/v2/repositories/shopsysbot/php-fpm/tags?page_size=10000' | jq -r '."results"[].images[] | "\(.digest)#\(.last_pushed)"'`

#echo ${repositoryJson}

#echo '\n\n'

#echo 'Starting:\n'

TOKEN=$(curl -u ${UNAME}:${UPASS} "https://auth.docker.io/token?service=registry.docker.io&scope=repository:shopsysbot/php-fpm:delete" | jq -r .token)

for row in ${repositoryJson}; do
    digest=`echo ${row} | cut -d '#' -f1`
    lastPushed=`echo ${row} | cut -d '#' -f2`

    if [ "$digest" != "null" ]
    then

        weekBack='9 days ago'

        datePushed=$(date --date "$lastPushed" +'%s')
        dateWeekBack=$(date --date "$weekBack" +'%s')

        if [ $datePushed -lt $dateWeekBack ]
        echo ${digest}
        echo "\n"
        then



            echo "https://registry.hub.docker.com/v2/shopsysbot/php-fpm/manifests/${digest}"
            echo "\n"

            # https://docs.docker.com/registry/spec/api/#deleting-an-image
            curl -s -X DELETE -H "Authorization: Bearer ${TOKEN}" https://registry.hub.docker.com/v2/shopsysbot/php-fpm/manifests/${digest}
            break
        fi
    fi
done

#echo curl -u ${UNAME}:${UPASS} -X DELETE https://registry.hub.docker.com/v2/shopsysbot/php-fpm/manifests/sha256:85717f5c3155dd5f5386e5b0cc3cd0005fecc5b5ea24c2e78af1a105ec660345
#curl -s -X DELETE -H "Authorization: JWT eyJ4NWMiOlsiTUlJQytqQ0NBcCtnQXdJQkFnSUJBREFLQmdncWhrak9QUVFEQWpCR01VUXdRZ1lEVlFRREV6c3lWMDVaT2xWTFMxSTZSRTFFVWpwU1NVOUZPa3hITmtFNlExVllWRHBOUmxWTU9rWXpTRVU2TlZBeVZUcExTak5HT2tOQk5sazZTa2xFVVRBZUZ3MHlNREV5TURFeU16SXpNREphRncweU1URXlNREV5TXpJek1ESmFNRVl4UkRCQ0JnTlZCQU1UT3pkYVRUVTZWVW96TkRwTFZWZE1PazFEUjFrNlZGQkJORHBGUVZGTE9rUllUalk2UTFWVlJEcFlObGxTT2t4TlNFVTZSRUpRUWpwU1RrcEZNSUlCSWpBTkJna3Foa2lHOXcwQkFRRUZBQU9DQVE4QU1JSUJDZ0tDQVFFQTFkS1BcLzdHZ0YyZEtYVjhOelNnOTJMQlowOWZWSEd4NkxySUtQemV6dWhcL2VJZExlUlZ0XC9TcVZxQTdCeXlOWlZRRkRrOTI5XC9SWVdhcWVuQWZ5RThGbnpNS1FoOE5scXIrOWg1TFVqMUJMV2s4c2YyajJGN1VnWjVKRThYYmFlSVhzcXRwdDhtYTNsdlY0VTJ4alwvNmp0TWNKc3ZvVXp0dXhOQ1FwSGhBVHA3NVNNWERQUXNPNEFYZEJiQWt1V3RcL0VvVDFtNExmR1RZXC9cL2VuSVYxQWlxUTdmdTZyM2F6SWdcL1E2TlRcL1lqcXJXbnRXWmNLWG9mSHlldjI3a0xkZXJIQnhZdGtVaGlDb0lkMndVVCs1c3lIODd6WmxyekJ5dTZVOUxINnZEY2hiSEJSWTFnSWY4dmc1UFlvR3RQM3pvdUttd3ZFWFB4WmZnTWhlOTRkUFQ1VFFJREFRQUJvNEd5TUlHdk1BNEdBMVVkRHdFQlwvd1FFQXdJSGdEQVBCZ05WSFNVRUNEQUdCZ1JWSFNVQU1FUUdBMVVkRGdROUJEczNXazAxT2xWS016UTZTMVZYVERwTlEwZFpPbFJRUVRRNlJVRlJTenBFV0U0Mk9rTlZWVVE2V0RaWlVqcE1UVWhGT2tSQ1VFSTZVazVLUlRCR0JnTlZIU01FUHpBOWdEc3lWMDVaT2xWTFMxSTZSRTFFVWpwU1NVOUZPa3hITmtFNlExVllWRHBOUmxWTU9rWXpTRVU2TlZBeVZUcExTak5HT2tOQk5sazZTa2xFVVRBS0JnZ3Foa2pPUFFRREFnTkpBREJHQWlFQThCZTZjWjRKcHZJVVRXVzhSNFFOODQ3RXE2VXNMcSsyNVhkTkhaRUZEZVlDSVFETlZFaCt6SnhPWVBDcnRhM2xRZUdGTWgwZzVQcGRpdUpsR0l2OTFDMnhPZz09Il0sImFsZyI6IlJTMjU2IiwidHlwIjoiSldUIn0.eyJzZXNzaW9uX2lkIjoiM0UxNjIzRUU3NkYwNTY0RDQzRkQxMjY4OTdBRTU5MTQiLCJpYXQiOjE2MTEyMjg0NjksImV4cCI6MTYxMzgyMDQ2OSwic3ViIjoiOGU4Y2Q2MTJhOWJkNGRlZDg3MWVlODZlZDFiMjMyMzciLCJ1c2VybmFtZSI6InNob3BzeXNib3QiLCJqdGkiOiIzRTE2MjNFRTc2RjA1NjRENDNGRDEyNjg5N0FFNTkxNCIsInVzZXJfaWQiOiI4ZThjZDYxMmE5YmQ0ZGVkODcxZWU4NmVkMWIyMzIzNyIsImVtYWlsIjoiIn0.jKBAMAD7A7uyTqaIO6I6bHVv20xi1rbLZ45jVxz2mbuNV0iNlMW7oCvTfrr7dduO96bwr2kayjKEo4fvG-goegaI43jkzRBu4JIv4pdqZ3VvBghv58CAGAXV1Z0sbelmRDfe8CjGEYAMYpctELYMqEuE7CFNi0XySDf76_T487as2wvWmb0Ovt2dOOfBrxcvVdIHr0dzRAMKd7FqgMGivb1-rCp4JVTpoe2FdeOW_d-iaYdNDuOP24-lrVD4PEtnxOEfe6lSNolfnX_laBW-Y3mAJ_QeV5db00X84kzBfob8QiPcLIDJPb5cjWoCenkfr7p9DyDFsrH7Zq9MEgd65A" https://registry.hub.docker.com/v2/shopsysbot/php-fpm/manifests/sha256:85717f5c3155dd5f5386e5b0cc3cd0005fecc5b5ea24c2e78af1a105ec660345
#curl --header "Authorization: Bearer ${TOKEN}" https://registry.hub.docker.com/v2/shopsysbot/php-fpm/manifests/sha256:85717f5c3155dd5f5386e5b0cc3cd0005fecc5b5ea24c2e78af1a105ec660345


