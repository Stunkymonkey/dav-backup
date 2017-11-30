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

# enter the service that is providing the dav-service (eg. "owncloud"/"baikal")
SERVICE="baikal"

# enter your login-username
DAVUSER="user"

# small letters (for owncloud/baikal)
ADDRESSBOOK="contacts"

# small letters (for owncloud/baikal)
CALENDAR="personal
holiday"

# date-format of output-file
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
```


## credentials

Also put your credentials into `~/.config/dav-backup/credentials`:

```
# put into
#~/.config/dav-backup/credentials

user=<Value of DAVUSER>
password=<your password to authenticate>

```
