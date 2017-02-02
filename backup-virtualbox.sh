#################Configuration#######################
ACCOUNT="askey"
PASSWD="123456"
IPADDR="10.194.20.33"
REMOTE_PATH="VirtualBox/redmin-12"
BACKUP_FOLDER="backup_folder"
FTP_DL_FOLDERNAME=$IPADDR
HOUR_RUN_BACKUP=01
MINUTE_RUN_BACKUP=00
BACKUP_FILE_NUM=3

#################Function###########################
function Backup(){

    #update the parameter again
    FOLDERNAME=`date +"%Y%m%d"`
    ZIPFILENAME=$FOLDERNAME".7z"
    
    #wget -r ftp://askey:123456@10.194.22.102/VirtualBox/redmin-12/
    wget -r "ftp://$ACCOUNT:$PASSWD@$IPADDR/$REMOTE_PATH/"
    mv $FTP_DL_FOLDERNAME $FOLDERNAME
    
    #compress
    7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on $ZIPFILENAME $FOLDERNAME
    #remove backup folder
    ret_7z=$?
    #echo "***********NelsonDBG - ret_7z is $ret_7z "
    if [ $ret_7z -eq 0 ]; then
    #if [ "$ret_7z" == "0" ]; then #it is ok too
        #move folder to backup folder first
        mv $FOLDERNAME $BACKUP_FOLDER

        backup_file_number=`ls *.7z | wc | awk -F ' ' '{print $1}'`
        #echo $backup_file_number
        if [ $backup_file_number -ge $BACKUP_FILE_NUM ]; then
            echo "$backup_file_number >= $BACKUP_FILE_NUM"
            #remove old data
            echo "Delete old information - $BACKUP_FOLDER"
            rm -rf $BACKUP_FOLDER

            #move backup file to backup folder
            mkdir -p $BACKUP_FOLDER
            mv *.7z $BACKUP_FOLDER
        fi
        sendmail -vt  < ok__backup.txt
    else
        sendmail -vt < fail_backup.txt
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
