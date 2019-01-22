
echo "1.    Checkout SOC code base:"
echo "11.   Branch Soc to 台灣向:"
echo "12.   Branch Soc to 大陸向:"
echo "2.    Checkout MCU code base:"
echo "3.    Checkout BLE code base:"
echo "31.   Branch BLE to 台灣向:"
echo "32.   Branch BLE to 大陸向:"
read option

case "$option" in 
    //"")
    //;;
    "1")
        git clone ssh://nelson_chung@bitbucket.askey.com.tw:7999/cmmicd12/cbg0200-d122-soc.git AM335x_0523
    ;;
    "11")
        git checkout -b VIG2_4G --track origin/VIG2_4G
    ;;
    "12")
        git checkout -b VIG2_4G_DFYL --track origin/VIG2_4G_DFYL
    ;;
    "2")
        git clone ssh://nelson_chung@bitbucket.askey.com.tw:7999/cmmicd12/cbg0200-d122-mcu.git VIG2_4G_MCU
    ;;
    "3")
        git clone ssh://USERNAME@bitbucket.askey.com.tw:7999/cmmicd12/cbg0200-d122-ble.git VIG_4G_BLE
    ;;
    "31")
        git checkout -b VIG_BLE --track origin/VIG_BLE
    ;;
    "32")
        git checkout -b DongfengYulon_BLE --track origin/DongfengYulon_BLE
    ;;
    *)
    echo "Not support"
    exit 1
    ;;
esac 
