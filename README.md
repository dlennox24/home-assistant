# home-assistant

# Restoring a backup

1. Create a fresh install of ubuntu server
1. Move the "Full System Backup" from Duplicati to the `/opt` folder and name it `backup.zip`

   ```shell
   sudo scp nas@192.168.1.X:/path/to/backup.zip /opt/backup.zip
   ```

1. Run the below block to begin the restore

   ```shell
   wget https://github.com/dlennox24/home-lab/archive/refs/heads/main.zip
   sudo mv home-lab-main/home-assistant/restore.sh
   sudo chmod +x restore.sh
   sudo ./restore.sh
   ```
