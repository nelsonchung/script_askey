#!/bin/bash

#請使用source add_path.sh的方式來執行，path才會立即生效
#Now always add current path
PWD=`pwd`
export PATH="${PATH}:$PWD"
echo "export PATH=\"\$PATH:$PWD\"" >> ~/.bashrc
