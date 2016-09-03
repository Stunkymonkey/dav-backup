#dav-backup
is a simple script, that downloads all your calendars and contacts from owncloud and stores them in a file

you can configure your data in a config file for automation:
```
#dav-backup

# the URL to your server
HOST="https://cloud.example.com"

# enter the service that is providing the dav-service (eg. "owncloud"/"baikal")
SERVICE="baikal"

# enter your login-username
DAVUSER="user"

# leave it empty, then you will be promted every time you use the script
PASSWORD="123456"

# small letters (for owncloud/baikal)
ADDRESSBOOK="contacts"

# small letters (for owncloud/baikal)
CALENDAR="personal
holiday"

# date-format of output-file
DATE=$(date +"%Y_%m_%d_%H_%M_%S")

```