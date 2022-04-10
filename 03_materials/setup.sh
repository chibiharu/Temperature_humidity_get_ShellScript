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
# カレントパスを取得
CPath=$(cd $(dirname $0); pwd)

# 実行ログ出力先パス(デフォルト：カレントディレクトリ)
SetUpLog=$CPath"/setuplog.log"


#####################################################################
## 資材
#####################################################################
### Rootユーザか判定 ###
function FuncRoot() {
  echo "### Start function FuncRoot ###"
  if [[ `whoami` != "root" ]]; then
    echo "rootユーザで実行してください。"
    exit 1
  else
    echo "rootユーザで実行されていることを確認しました。"
  fi
  echo "### End function FuncRoot ###"
}

### 事前準備 ###
function FuncPre() {
  echo "### Start function FuncPre ###"
  apt-get update
  apt-get upgrade -y
  echo "### End function FuncPre ###"
}

### Python開発ツール ###
function FuncInstallPython() {
  echo "### Start function FuncInstallPython ###"
  apt-get install build-essential python-dev
  python --version
  sudo unlink /usr/bin/python
  sudo ln -s python3 /usr/bin/python
  python --version
  echo "### End function FuncInstallPython ###"
}

### Git ###
# Git Latest
function FuncInstallGit() {
  echo "### Start function FuncInstallGit ###"
  apt-get install -y git
  git --version
  echo "### End function FuncInstallGit ###"
}

### Adafruit_Python_DHT ###
function FuncCloneAdafruit() {
  echo "### Start function FuncCloneAdafruit ###"
  git clone https://github.com/adafruit/Adafruit_Python_DHT.git
  python ./Adafruit_Python_DHT/setup.py install
  echo "### End function FuncCloneAdafruit ###"
}


#####################################################################
## メイン処理
#####################################################################
echo "### 処理中です... ###"
FuncRoot >> $SetUpLog
FuncPre >> $SetUpLog
FuncInstallPython >> $SetUpLog
FuncInstallGit >> $SetUpLog
FuncCloneAdafruit >> $SetUpLog
