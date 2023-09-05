# WayPoint を YAML ファイルに保存してロードとセーブ

## パッケージの取得
ノート PC で実行する
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

開いた RViz 上で waypoint の設置 -> yaml に保存 -> yaml の読み込み を行う。


