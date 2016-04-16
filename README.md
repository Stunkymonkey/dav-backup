#dav-backup
is a simple script, that downloads all your calendars and contacts from owncloud and stores them in a file

you can configure your data in a config file for automation:
```
#dav-backup

HOST="https://cloud.example.de"

OCUSER="user"

# leave it empty, then you will be promted every time you use the script
PASSWORD="123456"

# small letters (for owncloud)
ADDRESSBOOK="contacts"

# small letters (for owncloud)
CALENDAR="personal
holidays"

# date-format of output-file
DATE=$(date +"%Y_%m_%d_%H_%M_%S")
```