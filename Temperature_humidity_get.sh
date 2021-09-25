#######################################################################################
#
# <スクリプト名>
# 温湿度情報判定スクリプト
#
# <概要>
# 取得した温湿度情報をログ出力を行う
#
# <更新履歴>
# 20210906 - 新規作成
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

# ログ・ファイル
log_FILE="/var/log/temp_humi.log"

# 一時ファイル
sla_tmp_FILE="${current_path}/temp_humi_sla.log"

# CSVファイル
CSV_FILE="/var/log/temp_humi_${today}.csv"


#####################################################################
## 事前処理
#####################################################################

# ログ・ファイルがなかったら作成する
if [ ! -e log_FILE ]; then
  sudo touch ${log_FILE}
fi

# CSVファイルがなかったら作成する
if [ ! -e CSV_FILE ]; then
  sudo touch ${CSV_FILE}

fi


#####################################################################
## 温湿度を取得
#####################################################################

# 室内の温湿度を取得
python_kekka=`python <スクリプト存在パス>`
# 処理が成功しているか確認し、失敗していたら再トライする
if echo $python_kekka | grep Failed ; then
  python_kekka=`python <スクリプト存在パス>`
fi


######################################################################
## 関数：取得した温湿度情報から必要事項を各変数に格納
######################################################################
# -- 設定パラメータ情報 --
# [str_time] = 時刻
# [str_temp] = 温度
# [str_humi] = 湿度
#
#######################################################################

# 取得成功時の処理
function success_str_sed() {
  # 複数のスペースを1つに変換
  python_kekka=`echo $python_kekka | sed -e 's/(space)(space)*/(space)/g'`
  #python_kekka=`echo $python_kekka | sed -e "s/   / /g"`
  #python_kekka=`echo $python_kekka | sed -e "s/  / /g"`
  #python_kekka=`echo $python_kekka | sed -e "s/  / /g"`
echo $python_kekka
 # 配列に格納
  ary=(`echo $python_kekka`)
  # 配列から要素を抜き出す
  str_time=`echo ${ary[0]}`
  str_temp=`echo ${ary[1]}`
  str_humi=`echo ${ary[2]}`

  ### 取得した情報を整形 ###
  # 湿度値を整形
  str_temp=`echo $str_temp | sed -e "s/Temp=//g"`
  str_temp_long=`echo $str_temp | sed -e "s/*C//g"`
  str_temp_long=`echo $str_temp_long | awk '{printf("%d\n",$1)}'`
  # 温度値を整形
  str_humi=`echo $str_humi | sed -e "s/Humidity=//g"`
  str_humi_long=`echo $str_humi | sed -e "s/%//g"`
  str_humi_long=`echo $str_humi_long | awk '{printf("%d\n",$1)}'`
  echo $str_humi_long
}

# 取得失敗時の処理
function failed_str_sed(){
  failed_str=`echo $python_kekka | sed -e 's/(space)(space)*/(space)/g'`
  #failed_str=`echo $python_kekka | sed -e "s/   / /g"`
  #failed_str=`echo $failed_str | sed -e "s/  / /g"`
  failed_str=`echo $failed_str | sed -e "s/Failed//g"`
  failed_str=`echo $failed_str | sed -e "s/to//g"`
  failed_str=`echo $failed_str | sed -e "s/get//g"`
  failed_str=`echo $failed_str | sed -e "s/reading//g"`
  failed_str=`echo $failed_str | sed -e "s/Try//g"`
  failed_str=`echo $failed_str | sed -e "s/again!//g"`
}


###################################################################
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
function SLA() {
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

### 失敗時のログ出力 ###
function failed_logger() {
  echo -n $time | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Error_Code=[103]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Error=[GetFailed]" | sudo tee -a $log_FILE
  echo -n "   " | sudo tee -a $log_FILE
  echo -n "Massage=[Failed to get reading. Try again!]" | sudo tee -a $log_FILE
  echo "   " | sudo tee -a $log_FILE
}

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

### pythonスクリプトの出力結果によって処理を分岐する ###
if echo $python_kekka | grep Failed ; then
  # 取得失敗時の処理
  failed_str_sed
  failed_logger
else
  # 取得成功時の処理
  success_str_sed
  SLA
  writeing_csv_success
fi
