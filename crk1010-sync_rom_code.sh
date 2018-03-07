echo "======================================================================================="
PWD=`pwd`
echo $PWD
DST_PATH="/home/nelson_chung/mount_folder"
echo "Start to sync rom code"
date
mkdir -p "$DST_PATH/10.194.20.40"
echo 12345678 | sudo -S mount -t cifs -o username="nelson",password="12345678" //10.194.20.40/db50 "$DST_PATH/10.194.20.40"
mkdir -p ROM_Code
sudo mount -t cifs -o username="nelson_chung",password="2017ASDFghjk" "//10.1.118.196/ROM Code" /home/nelson_chung/mount_folder/ROM_Code
rsync -av "$DST_PATH/ROM_Code/CRK1010-D28" "$DST_PATH/10.194.20.40/CRK1010/Image"
echo "End to sync rom code"
date
