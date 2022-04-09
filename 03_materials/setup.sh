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

# 実行ログ出力先パス(デフォルト：カレントディレクトリ)
SetUpLog=$crrent_path"/SetUpLog_"$time".log"


#####################################################################
## 資材
#####################################################################
### 事前準備 ###
function FuncPre() {
  touch $SetUpLog
  apt-get update
  apt-get upgrade -y
}

### Python開発ツール ###
# Python 3.9.4
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

### Adafruit_Python_DHT ###
function FuncCloneAdafruit() {
  git clone https://github.com/adafruit/Adafruit_Python_DHT.git
  cd Adafruit_Python_DHT/
  python setup.py install
}

### Rootユーザか判定 ###
function FuncRoot() {
  if [ ${EUID:-${UID}} = 0 ]; then
      echo 'Try again as the Root user.'
      exit 2
  fi
}


#####################################################################
## メイン処理
#####################################################################
FuncRoot | tee -a $SetUpLog
FuncPre | tee -a $SetUpLog
FuncInstallPython | tee -a $SetUpLog
FuncInstallGit | tee -a $SetUpLog
FuncCloneAdafruit | tee -a $SetUpLog
