#################Configuration#######################
ACCOUNT="askey"
PASSWD="123456"
IPADDR="10.194.20.35"
REMOTE_PATH="VirtualBox/redmin-12"
BACKUP_FOLDER="backup_folder"
FTP_DL_FOLDERNAME=$IPADDR
HOUR_RUN_BACKUP=01
MINUTE_RUN_BACKUP=00

#################Function###########################
function Backup(){

    #update the parameter again
    FOLDERNAME=`date +"%Y%m%d"`
    ZIPFILENAME=$FOLDERNAME".7z"
    
    #move backup file to backup folder
    mkdir -p $BACKUP_FOLDER
    mv *.7z $BACKUP_FOLDER

    #wget -r ftp://askey:123456@10.194.22.102/VirtualBox/redmin-12/
    wget -r "ftp://$ACCOUNT:$PASSWD@$IPADDR/$REMOTE_PATH/"
    mv $FTP_DL_FOLDERNAME $FOLDERNAME
    #compress
    7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on $ZIPFILENAME $FOLDERNAME
    #remove backup folder
    7z_ret=$?
    if [ $7z_ret -eq 0 ]; then
        #remove old data
        rm -rf $FOLDERNAME
        rm -rf $BACKUP_FOLDER
    fi

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