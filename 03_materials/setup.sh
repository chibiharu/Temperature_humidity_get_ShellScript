#!/bin/bash
#######################################################################################
#
# <スクリプト名>
# スタートアップスクリプト
#
# <概要>
# 温湿度管理に必要なパッケージやモジュールをインストールする
#
# <更新履歴>
# 20220408 - 新規作成
#
#######################################################################################


#####################################################################
## 事前設定
#####################################################################
# 現在の時刻を取得
time=$(date '+%Y/%m/%d %T')
# カレントパスを取得
current_path=$(cd $(dirname $0); pwd)


#####################################################################
## 資材
#####################################################################
### 事前準備 ###
function FuncPre() {
  apt-get update
  apt-get upgrade -y
}

### Python開発ツール ###
# Python 3.9
function FuncInstallPython() {
  wget https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz
  tar zxvf Python-3.9.4.tgz
  cd Python-3.9.4
  ./configure
  make
  make install
  python3.9 -v
}

### Git ###
# Git Latest
function FuncInstallGit() {
  apt-get install -y git
  git --version
}
### 

# Rootユーザか判定
function FuncRoot() {
  if [ ${EUID:-${UID}} = 0 ]; then
      echo 'Try again as the Root user.'
      exit
  fi
}


#####################################################################
## メイン処理
#####################################################################
FuncRoot >> $SetUpLog
FuncPre >> $SetUpLog
FuncInstallPython >> $SetUpLog
FuncInstallGit >> $SetUpLog
