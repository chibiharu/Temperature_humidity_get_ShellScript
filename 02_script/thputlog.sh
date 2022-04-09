#######################################################################################
#
# <スクリプト名>
# 温湿度情報スクリプト
#
# <概要>
# 取得した温湿度情報を基に以下の処理を実行する
# - 温湿度情報のSLAを判定
#     - 判定結果をログとして出力
# - 温湿度情報をデータ(CSV)として出力
#
# <更新履歴>
# 20210906 - 新規作成
# 20220408 - 全体的な処理ロジックを更新
#
#######################################################################################
#!/bin/bash


#####################################################################
## 事前設定
#####################################################################

# 今日の日付を取得
today=$(date "+%Y%m%d")

# 現在の時刻を取得
time=$(date '+%Y/%m/%d %T')

# カレントパスを取得
current_path=$(cd $(dirname $0); pwd)


######################################################################
# パラメータ設定
######################################################################

# ログファイル
log_FILE="/var/log/temp_humi.log"

# CSVファイル
CSV_FILE="/var/log/temp_humi_${today}.csv"


#####################################################################
## 事前処理
#####################################################################

# ログ・ファイルがなかったら作成する
# if [ ! -e log_FILE ]; then
#   sudo touch ${log_FILE}
# fi


#####################################################################
## 温湿度を取得
#####################################################################

# 温湿度値取得スクリプトを実行
str_raw=`python current_path/basicdht22.py`


######################################################################
## 関数：取得した温湿度情報から必要事項を各変数に格納
######################################################################
# -- 設定パラメータ情報 --
# [str_time] = 時刻
# [str_temp] = 温度
# [str_humi] = 湿度
#
#######################################################################

# 関数：取得した温湿度情報から必要事項を各変数に格納
function FuncSedTH() {
 # 配列に格納
  ary=(`echo $str_raw`)
  # 配列から要素を抜き出す
  str_time=`echo ${ary[0]}`
  str_temp=`echo ${ary[1]}`
  str_humi=`echo ${ary[2]}`
}


####################################################################
## 関数：SLA判定
####################################################################
# -- 設定パラメータ情報 --
# <温度SLA>
# MAX = 30  MIN = 15
# <湿度SLA>
# MAX = 70  MIN = 30
#
#####################################################################

# SLAを判定
!!!!!!!!!!!!!!!!!! caseにする
!!!!!!!!!!!!!!!!!! SLA値をパラメータ設定に移動
function FuncSLA() {
  # 判定用の数値
  i=1
  # 温度を判定
  if [[ $str_temp_long -gt 15 ]] || [[ $str_temp_long -lt 30 ]] ; then
    i=2
    temp_logger
  fi
  # 湿度を判定
  if [[ $str_humi_long -gt 30 ]] || [[ $str_humi_long -lt 70 ]] ; then
    i=2
    humi_logger
  fi
  # SLAに合格した時の処理
  if [[ $i -eq 1 ]]; then
    success_logger
  fi
}


#####################################################################
## ログ出力
#####################################################################
# -- 処理概要 --
# 1. 
# 2. 
# 3. 
#
#####################################################################

### 温度異常検知時の処理 ###
function temp_logger() {
  echo -n $time | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Error_Code=[101]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Error=[TemperatureFailed]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Massage=[An abnormal value was detected in the temperature value]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Value=[" | sudo tee -a $log_FILE
  echo -n $str_temp | sudo tee -a $log_FILE
  echo "]" | sudo tee -a $log_FILE
}

### 湿度異常検知時の処理 ###
function humi_logger() {
  echo -n $time | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Error_Code=[102]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Error=[HumidityFailed]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Massage=[An abnormal value was detected in the Humidity value]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Value=[" | sudo tee -a $log_FILE
  echo -n $str_humi | sudo tee -a $log_FILE
  echo "]" | sudo tee -a $log_FILE
}

### SLA合格時の処理 ###
function success_logger() {
  echo -n $time | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Error_Code=[100]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Error=[Success]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Massage=[Processing completed successfully]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Value=[ " | sudo tee -a $log_FILE
  echo -n $str_temp | sudo tee -a $log_FILE
  echo -n " & " | sudo tee -a $log_FILE
  echo -n $str_humi | sudo tee -a $log_FILE
  echo " ]" | sudo tee -a $log_FILE
}


#####################################################################
## 温湿度情報一覧の作成
#####################################################################

### 成功時のCSVファイルへ取得情報を追記する処理 ###
function writeing_csv_success() {
  echo -n $str_time | sudo tee -a $CSV_FILE
  echo -n "   " | sudo tee -a $CSV_FILE
  echo -n $str_temp | sudo tee -a $CSV_FILE
  echo -n "   " | sudo tee -a $CSV_FILE
  echo $str_humi | sudo tee -a $CSV_FILE
}


#####################################################################
## メイン処理
#####################################################################
# -- 処理概要 --
# 1. 
# 2. 
# 3. 
#
#####################################################################
FuncSedTH
FuncSla
FuncWriteingCsv