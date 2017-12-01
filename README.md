# dav-backup

A simple script, that downloads all your calendars and addressbooks from owncloud or baikal and stores them in a file.

# configuration

## main

You can configure your data in a config file for automation:

```
#dav-backup
#~/.config/dav-backup/config

# the URL to your server
HOST="https://cloud.example.com"

# output of the tarpackage
OUT="~/.cache/backup"

# enter the service that is providing the dav-service (eg. "owncloud"/"baikal"/"radicale")
SERVICE="baikal"

# enter your login-username
DAVUSER="user"

# small letters (for owncloud/baikal/radicale)
ADDRESSBOOKS=("private" "work")

# small letters (for owncloud/baikal/radicale)
CALENDARS=("personal" "holiday")

# date-format of output-file
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
```

For `ADDRESSBOOKS` and `CALENDARS`, also values of the format `<id>:<name>` are allowed, while `<id>` is the identifier of your server and `<name>` is used in the filename.

## credentials

Also put your credentials into `~/.config/dav-backup/credentials`:

```
# put into
#~/.config/dav-backup/credentials

user=<Value of DAVUSER>
password=<your password to authenticate>

```
