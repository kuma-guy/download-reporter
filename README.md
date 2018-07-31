# download-reporter

Report ios downloads to slack

## Installtion

1, Enter vendor No.

https://github.com/kuma-guy/download-reporter/blob/master/DownloadCount_iOS.sh#L6

2, Enter slack url.

https://github.com/kuma-guy/download-reporter/blob/master/DownloadCount_iOS.sh#L60

3, Enter access token.
https://github.com/kuma-guy/download-reporter/blob/master/Reporter.properties#L1


## Crontab

```
0 9 * * *  /home/{YOUR_USER_NAME}/download-reporter/DownloadCount_iOS.sh
```
