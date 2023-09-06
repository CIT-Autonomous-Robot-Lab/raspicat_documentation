## 概要
ROS 2のRaspberry Pi Catシミュレータでウェイポイントナビゲーションをする方法について説明します。 
[Set Up/有線LAN（Ethernet）](../set_up/wired.md)および[Set Up/無線LAN（Wi-Fi）](../set_up/wireless.md)で、各設定が済んでいる前提で説明をします。

## WaypointをYAMLファイルに保存してロードとセーブ

## パッケージの取得
ノートPCで実行する
### クローン
``` bash
cd ~/raspicat2/src
git clone -b feat/tsukuba-challenge-2023-ex https://github.com/CIT-Autonomous-Robot-Lab/navigation2
```
### 過去のコミットに戻す
``` bash
cd ~/raspicat2/src/navigation2
git reset b893e538ffc9667bf0a3ab0c99070439f5521718
```

### ビルド
``` bash
cd ~/raspicat2
colcon build --packages-select raspicat_description emcl2 raspicat_setup_scripts raspicat_slam raspicat_speak2 raspicat_bringup raspicat_navigation raspicat raspicat_gazebo nav2_msgs nav2_rviz_plugins nav2_waypoint_follower
source install/setup.bash
```

### シミュレータ
``` bash
ros2 launch raspicat_gazebo raspicat_with_iscas_museum.launch.py
ros2 launch raspicat_navigation raspicat_nav2.launch.py map:=$HOME/map.yaml
ros2 service call /motor_power std_srvs/SetBool '{data: true}'
```

開いたRVizのパネル・ツールにあるボタンで  
ウェイポイントの設置 -> YAMLファイルに保存 -> YAMLファイルの読み込みを行う。
