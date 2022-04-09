# TemperatureHumidity-AcquisitionFunctionToRaspberryPi
## リポジトリ概要
Raspberry Piで室内の温湿度値の 計測 / 判定 / 管理 を行う。

## 前提
- Raspberry Piに温湿度センサー「AM2302」が接続されていること
- GPIOピンは23番に接続していること

## ファイル説明
| ファイル名 | 説明 |
| -- | -- |
| README.md | - |
| common.conf | パラメータファイル ※全スクリプト共通 |
| basicdht22.py | センサーとDHT22を利用して温湿度値を計測する |
| thputlog.sh | 計測した温湿度値をログ形式で出力する |
| thputcsv.sh | 計測した温湿度値をデータ(CSV)形式で出力する |
| thputall.sh | 計測した温湿度値のログ出力とデータ(CSV)出力の両処理を実行する |
| logrotate.sh | thputall.sh, thputog.shで出力したログファイルのローテートを行う |
| setup.sh | スタートアップスクリプト, 本ライブラリの利用に必要なモジュールを一通りインストールする |

## リポジトリ階層
```
./
├ 01_param/
   └ common.conf
├ 02_script/
   └ basicdht22.py
   └ thputlog.sh
   └ thputcsv.sh
   └ thputall.sh
   └logrotate.sh
   └ logrotate_log.sh
├ 03_materials/
   └ setup.sh/
└ README.md
```

## 使用方法
- 初めて利用される方
1. 任意のディレクトリへライブラリをダウンロードします。
```bash
git clone https://github.com/chibiharu/TemperatureHumidity-AcquisitionFunctionToRaspberryPi.git
```
2. スタートアップスクリプトを実行します。
```bash
cd TemperatureHumidity-AcquisitionFunctionToRaspberryPi/03_materials
sudo ./setup.sh
```
3. パラメータファイルを更新します。※デフォルトでも動作します
```bash
cd TemperatureHumidity-AcquisitionFunctionToRaspberryPi/01_param
vi common.conf
```

## 参考
- [【DHT22】Raspberry PiとAWSを連携して室内の温度・湿度を計測する](https://chibinfra-techblog.com/raspberrypi-dht22-th/)
