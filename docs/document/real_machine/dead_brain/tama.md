# SSH でキャットにつなぐ（有線 LAN ）
```
source ~/.bashrc
ssh ubuntu@$ETHERNET_IP
```

## USB 指し直しが必要

# キャリブレーション
```
ros2 launch imu_calibration_data imu_c_data_launch.py
```

# マップをとる
Raspberry Piで実行
```
ros2 launch raspicat raspicat.launch.py
```
```
ros2 service call /motor_power std_srvs/SetBool '{data: true}'
```
```
ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
```
```
ros2 bag record -a
```

## 取得したrosbagをノートPCに移動(PC側)(無線Ver)
```
sudo scp -r ubuntu@192.168.12.1:~/取ったrosbagのディレクトリ名 ~/
```

#### USBで別のPCに

# マップ作成（別のPC）
```
ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
```
```
ros2 bag play -r 1 --clock 100 取ったrosbagのディレクトリ名
```
```
ros2 run nav2_map_server map_saver_cli -f ~/つけたいマップの名前
```

## マップ加工

USBでマップをナビゲーションをするPC持って来る

# 複数マップを使う準備
ノートPCで実行
```
cd ~/raspicat2/src/raspicat_slam_navigation
git switch feat/localization-and-navigation-map
```

## マップの保存先
`~/raspicat2/src/raspicat_slam_navigation/raspicat_slam/config/maps`

`.yaml` と `.pgm` を一緒に入れる。

## 二種類のマップを設定
`~/raspicat2/src/raspicat_slam_navigation/raspicat_navigation/config/param/nav2.param.yaml`
```
navigation_map_server:
    ros__parameters:
        use_sim_time: False
        # ↓ を修正（絶対パスで！）
        yaml_filename: "/home/USER/raspicat2/src/raspicat_slam_navigation/raspicat_slam/config/maps/NAME.yaml"

localization_map_server:
    ros__parameters:
        use_sim_time: False
        # ↓ を修正（絶対パスで！）
        yaml_filename: "/home/USER/raspicat2/src/raspicat_slam_navigation/raspicat_slam/config/maps/NAME.yaml"
```

## ビルド
ノートPCで実行

```
cd ~/raspicat2
colcon build --packages-select raspicat_description emcl2 raspicat_setup_scripts raspicat_slam raspicat_speak2 raspicat_bringup raspicat_navigation raspicat raspicat_gazebo nav2_waypoint_follower nav2_rviz_plugins nav2_msgs raspimouse_msgs teleop_twist_joy
. install/setup.bash 
```

# ナビゲーション

!!! Info
    キャリブレーションした？？？

Raspberry Piで実行
```
ros2 launch raspicat raspicat.launch.py
```

ノートPCで実行
```
ros2 service call /motor_power std_srvs/SetBool '{data: true}'
ros2 launch raspicat_navigation raspicat_nav2.launch.py
```

