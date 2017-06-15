#################Configuration#######################
ACCOUNT="askey"
PASSWD="123456"
IPADDR="10.194.20.33"
REMOTE_PATH="VirtualBox/redmin-12"
#test url
#REMOTE_PATH="VirtualBox/redmin-12/Logs"
BACKUP_FOLDER="bk_folder"
FTP_DL_FOLDERNAME=$IPADDR
HOUR_RUN_BACKUP=00
MINUTE_RUN_BACKUP=00
BACKUP_FILE_NUM=6
BACKUP_SERVER_IP_ADDR="10.194.8.32"
FTP_ACCOUNT="askey"
FTP_PASSWD="123456"
REMOVE_FOLDER_AFTER_COMPRESS_DONE="1"
ADDITIONAL_FILE="moreinfo.txt"
RESULT_FILE="result.txt"
BACKUP_RESULT=0
#COMPRESS_MECHANISM="7Z"
COMPRESS_MECHANISM="TAR"

#################Function###########################
function Initial(){
    rm $ADDITIONAL_FILE
    rm $RESULT_FILE
    BACKUP_RESULT=0
}

function Backup(){
    
    Initial
    echo "Start to backup system" >> $ADDITIONAL_FILE
    date >> $ADDITIONAL_FILE
    echo "" >> $ADDITIONAL_FILE
    
    #update the parameter again
    FOLDERNAME=`date +"%Y%m%d"`
    if [ $COMPRESS_MECHANISM == "7Z" ] ;then
        FILENAMEEXTENSION="7z"
    elif [ $COMPRESS_MECHANISM == "TAR" ] ;then
        FILENAMEEXTENSION="tar.gz"
    fi
    ZIPFILENAME=$FOLDERNAME"."$FILENAMEEXTENSION
    
    #wget -r ftp://askey:123456@10.194.22.102/VirtualBox/redmin-12/
    wget -r "ftp://$ACCOUNT:$PASSWD@$IPADDR/$REMOTE_PATH/"
    echo "mv $FTP_DL_FOLDERNAME $FOLDERNAME"
    mv $FTP_DL_FOLDERNAME $FOLDERNAME

    #output information
    echo "The size of $FOLDERNAME is " >> $ADDITIONAL_FILE
    du -sh $FOLDERNAME >> $ADDITIONAL_FILE
    echo "" >> $ADDITIONAL_FILE
    
    #compress
    if [ $COMPRESS_MECHANISM == "7Z" ] ;then
        7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on $ZIPFILENAME $FOLDERNAME
    elif [ $COMPRESS_MECHANISM == "TAR" ] ;then
        tar zcvf $ZIPFILENAME $FOLDERNAME 
    fi
    ret_comparess=$?
    sync

    #output information
    echo "The size of $ZIPFILENAME is " >> $ADDITIONAL_FILE
    ls -alht $ZIPFILENAME >> $ADDITIONAL_FILE
    echo "" >> $ADDITIONAL_FILE

    #remove directly because the disk size is not enough.
    if [ $REMOVE_FOLDER_AFTER_COMPRESS_DONE == "1" ]; then
        echo "remove $FOLDERNAME directly"
        rm -rf $FOLDERNAME
    fi

    #backup to another server
    #SyncToBackupServer_wput $ZIPFILENAME
    #ret_comparess=$?

    if [ $ret_comparess -eq 0 ]; then
    #if [ "$ret_comparess" == "0" ]; then #it is ok too
        if [ $REMOVE_FOLDER_AFTER_COMPRESS_DONE != "1" ]; then
            #move folder to backup folder first
            mv $FOLDERNAME $BACKUP_FOLDER
        fi

        mv $ZIPFILENAME $BACKUP_FOLDER
        find $BACKUP_FOLDER -type f -mtime +$BACKUP_FILE_NUM -exec rm '{}' \;

        BACKUP_RESULT=1
    else
        BACKUP_RESULT=0
    fi

    echo "End to backup system" >> $ADDITIONAL_FILE
    date >> $ADDITIONAL_FILE
    echo "" >> $ADDITIONAL_FILE

    if [ $BACKUP_RESULT -eq 1 ]; then
        cat ok_backup.txt >> $RESULT_FILE
        cat $ADDITIONAL_FILE >> $RESULT_FILE
    else
        cat fail_backup.txt >> $RESULT_FILE
        cat $ADDITIONAL_FILE >> $RESULT_FILE
    fi
    sendmail -vt  < $RESULT_FILE

    #If we backup the file to backup server, we need to rm $ZIPFILENAME here.
    #rm $ZIPFILENAME
    #sync
}

function SyncToBackupServer_wput(){
    #wput test.txt ftp://askey:123456@10.194.8.32/
    wput $1 ftp://$FTP_ACCOUNT:$FTP_PASSWD@$BACKUP_SERVER_IP_ADDR/
}
function SyncToBackupServer(){
  #ftp -n $BACKUP_SERVER_IP_ADDR
  #user $FTP_ACCOUNT $FTP_PASSWD
  #binary
  #put $1 
  #bye
  #EOC
ftp -n <<END
open $BACKUP_SERVER_IP_ADDR
user $FTP_ACCOUNT $FTP_PASSWD
binary
put $1 
bye
END
}
#################Start##############################

#Create $BACKUP_FOLDER first
mkdir -p $BACKUP_FOLDER

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
        Backup
        echo "End to backup system"
    fi
    sleep 60
done
 
echo "End to backup system"
