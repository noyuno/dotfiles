
sudo certbot certonly --standalone -t 
    -d noyuno.space
    -d dir.noyuno.space
    -d git.noyuno.space
    -d file.noyuno.space
    -d files.noyuno.space
    -d storage.noyuno.space
    -d drive.noyuno.space
    -d s.noyuno.space
    -d p.noyuno.space
    -d vps.noyuno.space
    -d record.noyuno.space
    -d status.noyuno.space
    -d kanban.noyuno.space
    -d bot.noyuno.space
    -d trash.noyuno.space
    -d www.noyuno.space
    -d blog.noyuno.space
sudo cp /etc/letsencrypt/live/noyuno.space/cert.pem /var/www/html/ca/ca.crt
openssl x509 -outform der -in /var/www/html/ca/ca.crt >/var/www/html/ca/ca.der

