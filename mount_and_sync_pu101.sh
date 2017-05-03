sudo mount -t cifs -o username="nelson_chung",password="12345678" //10.1.112.61/pu101 /media/nelson_chung/pu101
sudo mount -t cifs -o username="nelson_chung",password="12345678" //10.1.112.61/pu101_share /media/nelson_chung/pu101_share
rsync -av /media/nelson_chung/pu101 /media/nelson_chung/e95d4a9b-b21c-4442-b6e9-5a2a619d043d/Shared/
rsync -av /media/nelson_chung/pu101_share /media/nelson_chung/e95d4a9b-b21c-4442-b6e9-5a2a619d043d/Shared/

