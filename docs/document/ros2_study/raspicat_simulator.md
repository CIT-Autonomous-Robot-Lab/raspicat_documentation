# ROS 2のシミュレータでRaspicatを動かそう！

## 概要

実機のRaspicatを動かす前にシミュレータで遊んでROS 2、SLAM、Navigationの感覚を身につけましょう。

## パッケージのインストール方法

```
mkdir ~/raspicat_sim_ws/src -p
cd ~/raspicat_sim_ws
git clone -b ros2 https://github.com/rt-net/raspicat_ros.git src/raspicat_ros
git clone -b ros2 https://github.com/rt-net/raspicat_description.git src/raspicat_description
git clone -b ros2 https://github.com/rt-net/raspicat_sim.git src/raspicat_sim
git clone -b ros2 https://github.com/rt-net/raspicat_slam_navigation.git src/raspicat_slam_navigation

rosdep update
rosdep install -r -y --from-paths --ignore-src ./

colcon build --symlink-install

./src/raspicat_gazebo/scripts/download_gazebo_models.sh
```

## 実行方法

* Raspicatをシミュレータで動かすだけ
```
ros2 launch raspicat_gazebo raspicat_with_iscas_museum.launch.py
ros2 service call /motor_power std_srvs/SetBool '{data: true}'
ros2 launch raspicat_bringup joy.launch.py output_vel:=cmd_vel
```

* SLAM（slam-toolbox）
```
ros2 launch raspicat_gazebo raspicat_with_iscas_museum.launch.py
ros2 service call /motor_power std_srvs/SetBool '{data: true}'
ros2 launch raspicat_bringup joy.launch.py output_vel:=cmd_vel
ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
ros2 run nav2_map_server map_saver_cli -f ~/map
```

* Navigation（Nav 2）
```
ros2 launch raspicat_gazebo raspicat_with_iscas_museum.launch.py
ros2 service call /motor_power std_srvs/SetBool '{data: true}'
ros2 launch raspicat_navigation raspicat_nav2.launch.py
```