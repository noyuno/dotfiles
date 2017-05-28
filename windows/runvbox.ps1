start-process -wait -filepath "C:\Program Files\Oracle\VirtualBox\VBoxManage.exe" -argumentlist startvm , "Ubuntu" , --type , headless
& "C:\Program Files (x86)\Xming\Xming.exe" ":0" -clipboard -multiwindow -dpi 92
& "C:\tools\putty\PLINK.EXE" -X -P 2222 noyuno@localhost mate-terminal
