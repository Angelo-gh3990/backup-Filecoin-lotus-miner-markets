# /bin/bash
#
while true
do
#
NOW=$( date '+%F_%H:%M:%S' )
#
BK_DIR=/zfs-pool/lotus_data/backup
#
find $BK_DIR/* -mtime +30 -exec rm {} \;
#
#create markets backup
lotus-miner --call-on-markets backup $BK_DIR/markets_backup_$NOW.cbor
cp /root/.lotusmarkets/config.toml $BK_DIR/markets_config_$NOW.toml
cp /root/.lotusmarkets/storage.json $BK_DIR/markets_storage_$NOW.json
cp /root/.lotusmarkets/token $BK_DIR/markets_token_$NOW
cp /root/.lotusmarkets/token $BK_DIR/markets_api_$NOW
#
sleep 60
#
#create miner backup
lotus-miner backup $BK_DIR/miner_backup_$NOW.cbor
cp /root/.lotusminer/config.toml $BK_DIR/miner_config_$NOW.toml
cp /root/.lotusminer/storage.json $BK_DIR/miner_storage_$NOW.json
cp /root/.lotusminer/token $BK_DIR/miner_token_$NOW
cp /root/.lotusminer/api $BK_DIR/miner_api_$NOW
#
#clean up older then 3 months
find /nfs-zfs-pool/storage3-nfs/backup-f01864397/* -mtime +93 -type f -delete
#rsync files remotely
rsync -av $BK_DIR/* /nfs-zfs-pool/storage3-nfs/backup-f01864397/
#
        echo "looped at: "$NOW
        sleep 86400
done
