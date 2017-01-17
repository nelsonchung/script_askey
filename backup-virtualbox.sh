#################Configuration#######################
ACCOUNT="askey"
PASSWD="123456"
IPADDR="10.194.22.102"
REMOTE_PATH="VirtualBox/redmin-12"
BACKUP_FOLDER="backup_folder"
FOLDERNAME=`date +"%Y%m%d"`
ZIPFILENAME=$FOLDERNAME".7z"
HOUR_RUN_BACKUP=01
MINUTE_RUN_BACKUP=00

#################Function###########################
function Backup(){
    #move backup file to backup folder
    mkdir -p $BACKUP_FOLDER
    mv *.7z $BACKUP_FOLDER

    #wget -r ftp://askey:123456@10.194.22.102/VirtualBox/redmin-12/
    wget -r "ftp://$ACCOUNT:$PASSWD@$IPADDR/$REMOTE_PATH/" -O $FOLDERNAME
    #compress
    7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on $ZIPFILENAME $FOLDERNAME
    #remove backup folder
    rm -rf $FOLDERNAME

    #remove old data
    rm -rf $BACKUP_FOLDER
    sync
}

#################Start##############################


while [ 1 ]
do
    HOUR=`date +"%H"`
    MINUTE=`date +"%M"`
    #echo "HOUR is $HOUR"
    #echo "MINUTE is $MINUTE"
    #echo "Now time is $HOUR:$MINUTE $DAY_OF_WEEK"
    #echo "Alert time is $HOUR_RUN:$MINUTE_RUN "

    if [ "$HOUR" == "$HOUR_RUN_BACKUP" ] && [ "$MINUTE" == "$MINUTE_RUN_BACKUP" ]; then
        echo "Start to backup system"
        date
        Backup
        date
    fi
    sleep 60
done
 
echo "End to backup system"
