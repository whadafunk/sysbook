# Installing ocalmfuse for mounting google-drive


$ sudo add-apt-repository ppa:alessandro-strada/ppa
$ sudo apt-get update
$ sudo apt-get install google-drive-ocamlfuse

$ google-drive-ocamlfuse

$ mkdir googleDriveRemoteDir
$ google-drive-ocamlfuse ./googleDriveRemoteDir/
$ ls -l ./googleDriveRemoteDir/
[...]
-rw-rw-r-- 1 francesco francesco 8399 apr 21  2023 'Test Document.odt'
deb http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main
deb-src http://ppa.launchpad.net/alessandro-strada/ppa/ubuntu xenial main
