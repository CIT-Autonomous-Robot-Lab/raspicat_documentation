# オンラインマッピング無線通信編？！

## 概要
Raspberry Pi Catで**オンラインマッピング(SLAM)**を行う方法を説明します。

## 必要な物

[Raspberry Pi 4BとノートPCで無線を行うための設定](https://uhobeike.github.io/raspicat_documentation/document/environment/wireless/wireless_raspi4/)が
済んでいる前提で話を進めてきます。

2D LiDARの電源はポータブル電源から取ります。

Raspberry Pi動作時に電源を取る時は**ショート**に気を付けましょう。

| Hardware            |                  | 
| ------------------- | ---------------- | 
| Raspberry Pi Cat    | ノートPC         | 
| Joystick controller | 2D LiDAR（遠くまで見れるかつデータにノイズが少ないものが良い）         | 
| IMU（無くても大丈夫） |                  | 

## 実行コマンド

ここで注意ですが動かす前は**非常停止スイッチがOFF**になっていることを確認しましょう。

```
# Raspberry Pi 4B
roslaunch raspicat_navigation raspicat_bringup.launch urg_ether:=false urg_usb:=true waypoint_navigation:=false urg_serial_port:=/dev/ttyACM0 
```

```
# ノートPC
roslaunch raspicat_slam_navigation slam_remote_pc.launch
```

```
# Joystick controllerを接続している方で実行を行う
roslaunch raspicat_gamepad_controller logicool.launch
```

↓`Raspberry Pi 4B`のみでナビゲーションを行う場合は`Raspberry Pi 4B`に保存すると良いかもしれません。

```
# Raspberry Pi 4B（マッピング完了後）
rosrun map_server map_saver -f ~/map
```