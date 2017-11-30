#dav-backup
is a simple script, that downloads all your calendars and contacts from owncloud and stores them in a file

you can configure your data in a config file for automation:
```
#dav-backup
#~/.config/dav-backup/config

# the URL to your server
HOST="https://cloud.example.com"

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
DATE=$(date +"%Y_%m_%d_%H_%M_%S")

```

Also put your credentials into `~/.config/dav-backup/credentials`:

```
# put into
#~/.config/dav-backup/credentials

user=<Value of DAVUSER>
password=<your password to authenticate>

```
