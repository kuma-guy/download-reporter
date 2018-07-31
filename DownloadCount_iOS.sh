IFS=$'\t'
# for mac
DATE=`date -v-2d +"%Y%m%d"`
# for centos
#DATE=`date --date '2 day ago' +%Y%m%d`
VENDOR_NO=
ORIGINAL_FILE="S_D_${VENDOR_NO}_${DATE}.txt"
NEW_FILE="S_D_${VENDOR_NO}_${DATE}.tsv"

# Fetch report file from itunes store
java -jar Reporter.jar p=Reporter.properties Sales.getReport ${VENDOR_NO}, Sales, Summary, Daily, ${DATE}

# Rename file
gunzip ${ORIGINAL_FILE}.gz
mv ${ORIGINAL_FILE} ${NEW_FILE}

count=0
reinstallCount=0
updateCount=0
i=0

# Count number of downloads from tsv
while read LINE; do
    # Skip first row
    if [ "$i" -ne 0 ]
    then
        tsvList=(`echo "$LINE"`)

        # Product Type Identifier
        # 1 => Donwloads
        # 3 => Reinstalls
        # 7 => Updates

        # We count only number of downloads
        if [ ${tsvList[6]} -eq 1 ]
         then
          let count=${count}+tsvList[7]
        fi
        if [ ${tsvList[6]} -eq 3 ]
         then
          let reinstallCount=${reinstallCount}+tsvList[7]
        fi
        if [ ${tsvList[6]} -eq 7 ]
         then
          let updateCount=${updateCount}+tsvList[7]
        fi


    fi
    let i=${i}+1
done < ${NEW_FILE}
rm ${NEW_FILE}

echo ${count}
echo ${reinstallCount}
echo ${updateCount}

# Slackに通知
payload='payload={"channel": "#channel-name", "username": "DL Report Bot", "text": "一昨日('${DATE}')のiOSダウンロード者数は:'$count'\n再インストール数:'$reinstallCount'\nアップデート数:'$updateCount'", "icon_emoji": ":ghost:"}'
curlScript="curl -X POST --data '"$payload"' SLACK_URL"
eval ${curlScript}