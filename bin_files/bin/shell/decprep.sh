#!/usr/bin/env bash

ramdisk create 500
ln -s /Volumes/ramdisk rd

cp ~/.vimrc rd/vimrc
>>rd/vimrc echo 'set nobackup'
>>rd/vimrc echo 'set nowritebackup'
>>rd/vimrc echo 'set noundofile'

 >rd/decvim echo '#!/usr/bin/env bash'
>>rd/decvim echo '/usr/local/bin/vim -u vimrc -i viminfo "$@"'
chmod 755 rd/decvim

