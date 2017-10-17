#!/bin/bash -e

. $HOME/dotfiles/bin/dffunc

postfix() {
    aptinstall postfix dovecot-imapd

    cat << EOF | tee /etc/postfix/main.cf

# See /usr/share/postfix/main.cf.dist for a commented, more complete version

mail_owner=postfix

smtpd_banner = $myhostname ESMTP $mail_name (Raspbian)
biff = no

# appending .domain is the MUA's job.
append_dot_mydomain = no

# Uncomment the next line to generate "delayed mail" warnings
#delay_warning_time = 4h

readme_directory = no

# TLS parameters
smtpd_tls_cert_file=/etc/ssl/certs/ssl-cert-snakeoil.pem
smtpd_tls_key_file=/etc/ssl/private/ssl-cert-snakeoil.key
smtpd_use_tls=yes
smtpd_tls_session_cache_database = btree:${data_directory}/smtpd_scache
smtp_tls_session_cache_database = btree:${data_directory}/smtp_scache

smtpd_sasl_type=dovecot
smtpd_sasl_path=private/auth
smtpd_sasl_auth_enable = yes
smtpd_sasl_security_options = noanonymous
smtpd_sasl_local_domain = $myhostname
smtpd_recipient_restrictions = permit_mynetworks,permit_auth_destination,permit_sasl_authenticated,reject

# See /usr/share/doc/postfix/TLS_README.gz in the postfix-doc package for
# information on enabling SSL in the smtp client.

smtpd_relay_restrictions = permit_mynetworks permit_sasl_authenticated defer_unauth_destination
myhostname = pi.noyuno.mydns.jp
mydomain=noyuno.mydns.jp
myorigin = $mydomain
alias_maps = hash:/etc/aliases
alias_database = hash:/etc/aliases
mydestination = localhost, localhost.$mydomain, $myhostname, $mydomain
relayhost = 
mynetworks = 127.0.0.0/8 [::ffff:127.0.0.0]/104 [::1]/128, 192.168.11.0/24
mailbox_size_limit = 0
recipient_delimiter = +
inet_interfaces = all
local_recipient_maps = unix:passwd.byname $alias_maps
mynetworks_style = subnet
home_mailbox=Maildir/

sendmail_path = /usr/sbin/postfix
newaliases_path = /usr/bin/newaliases
mailq_path = /usr/bin/mailq
setgid_group = postdrop
# 50MB
message_size_limit = 52428800
# 1GB
mailbox_size_limit = 1073741824

EOF

    sudo newaliases

    cat << "EOF" | patch -bN
--- dovecot.conf	2017-10-17 02:22:41.533252093 +0900
+++ /etc/dovecot/dovecot.conf	2017-10-17 02:23:21.213270784 +0900
@@ -27,7 +27,7 @@
 # "*" listens in all IPv4 interfaces, "::" listens in all IPv6 interfaces.
 # If you want to specify non-default ports or anything more complex,
 # edit conf.d/master.conf.
-#listen = *, ::
+listen = *, ::
 
 # Base directory where to store runtime data.
 #base_dir = /var/run/dovecot/

--- conf.d/10-auth.conf	2017-10-17 02:29:08.033430451 +0900
+++ /etc/dovecot/conf.d/10-auth.conf	2017-10-17 02:27:26.103384197 +0900
@@ -7,7 +7,7 @@
 # matches the local IP (ie. you're connecting from the same computer), the
 # connection is considered secure and plaintext authentication is allowed.
 # See also ssl=required setting.
-#disable_plaintext_auth = yes
+disable_plaintext_auth = no
 
 # Authentication cache size (e.g. 10M). 0 means it's disabled. Note that
 # bsdauth, PAM and vpopmail require cache_key to be set for caching to be used.
@@ -97,7 +97,7 @@
 #   plain login digest-md5 cram-md5 ntlm rpa apop anonymous gssapi otp skey
 #   gss-spnego
 # NOTE: See also disable_plaintext_auth setting.
-auth_mechanisms = plain
+auth_mechanisms = plain login
 
 ##
 ## Password and user databases
--- conf.d/10-mail.conf	2017-10-17 02:28:41.953418668 +0900
+++ /etc/dovecot/conf.d/10-mail.conf	2017-10-17 02:33:33.123548251 +0900
@@ -27,7 +27,7 @@
 #
 # <doc/wiki/MailLocation.txt>
 #
-# mail_location = mbox:~/mail:INBOX=/var/mail/%u
+mail_location = maildir:~/Maildir
 
 # If you need to set multiple mailbox locations or want to change default
 # namespace settings, you can do it by defining namespace sections.
--- conf.d/10-master.conf	2017-10-17 02:28:41.953418668 +0900
+++ /etc/dovecot/conf.d/10-master.conf	2017-10-17 02:35:46.963606413 +0900
@@ -93,9 +93,11 @@
   }
 
   # Postfix smtp-auth
-  #unix_listener /var/spool/postfix/private/auth {
-  #  mode = 0666
-  #}
+  unix_listener /var/spool/postfix/private/auth {
+    mode = 0666
+    user=postfix
+    group=postfix
+  }
 
   # Auth process is run as this user.
   #user = $default_internal_user

EOF

    dfx sudo ufw allow 25 # smtp
    dfx sudo ufw allow 587 # submission
    dfx sudo ufw allow 143 # imaps
    dfx sudo ufw allow 993 # imap
    dfx sudo systemctl restart postfix
    dfx sudo systemctl restart dovecot
}

