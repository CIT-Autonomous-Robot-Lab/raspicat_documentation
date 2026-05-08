## 概要
Raspberry Pi Catで地図作成をする方法について説明します。 
予め[PCの設定](../1_laptopsetup)、[Raspberry Piの設定](../3_raspisetup)、
（LIVOX MID-360を使用する場合は、[無線接続設定](../4_wireless)、[MID360の接続設定](../5_livox)）
を完了してからこちらに進んでください。

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |
| Raspberry Pi Cat（Raspberry Pi 4B+） | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |
| ------------------- |
| ノートPC            |
| Raspberry Pi Cat（Raspberry Pi 4B+） | 
| LANケーブル（有線通信の場合） |
| 2D LiDAR（[北陽](https://www.hokuyo-aut.co.jp/search/single.php?serial=21)）or 3D LiDAR（[Livox](https://www.livoxtech.com/jp/mid-360)） | 
| Joystick Controller |


## 地図作成（マッピング）

=== "Offline Mapping"

    === "Serial LiDAR"
        #### Raspberry Piでの実行
    
        コントローラはRaspberry Piに接続
        （PCから操作する場合は，[こちら](../6_teleop)を参照）
        ```sh
        ros2 launch raspicat raspicat.launch.py
        ros2 service call /motor_power std_srvs/SetBool '{data: true}'
        ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
        ```
        #### ノートPCでの実行
        以下のコマンドでセンサデータを取得、ロボットを動かした後ctrl+Cで保存
        ```sh
        # 全トピックを取得したい場合
        ros2 bag record -a -o ${HOME}/rosbag_mapping/
    
        # 特定のトピックのみを取得したい場合
        ros2 bag record -o ${HOME}/rosbag_mapping/ /odom /scan /tf /tf_static
        ```
    
        #### ノートPCでの実行（rosbag保存後）
    
        ```sh
        ros2 bag play -r 1 --clock 100 $HOME/rosbag_mapping
        ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
        # ~/map に保存
        ros2 run nav2_map_server map_saver_cli -f ~/map
        ```

    === "LIVOX LiDAR"
        #### Raspberry Piでの実行
    
        コントローラはRaspberry Piに接続
        （PCから操作する場合は，[こちら](../6_teleop)を参照）
        ```sh
        ros2 launch raspicat raspicat.launch.py
        ros2 service call /motor_power std_srvs/SetBool '{data: true}'
        ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
        ```

        #### ノートPCでの実行
        以下のコマンドでセンサデータを取得、ロボットを動かした後ctrl+Cで保存
        ```sh
        ros2 launch livox_ros_driver2 msg_MID360_launch.py
        ros2 launch pointcloud_to_laserscan mid360_pointcloud2_to_laserscan.launch.py

        # 全トピックを取得したい場合
        ros2 bag record -a -o ${HOME}/rosbag_mapping/
    
        # 特定のトピックのみを取得したい場合
        ros2 bag record -o ${HOME}/rosbag_mapping/ /odom /scan /tf /tf_static
        ```
    
        #### ノートPCでの実行（rosbag保存後）
    
        ```sh
        ros2 bag play -r 1 --clock 100 $HOME/rosbag_mapping
        ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
        # ~/map に保存
        ros2 run nav2_map_server map_saver_cli -f ~/map
        ```

=== "Online Mapping"

    === "Serial LiDAR"
        #### Raspberry Piでの実行
    
        コントローラはRaspberry Piに接続
        ```sh
        ros2 launch raspicat raspicat.launch.py
        ros2 service call /motor_power std_srvs/SetBool '{data: true}'
        ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
        ```
    
        #### ノートPCでの実行
        ```sh
        ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
        # ~/map に保存
        ros2 run nav2_map_server map_saver_cli -f ~/map
        ```

    === "LIVOX LiDAR"

        #### Raspberry Piでの実行
    
        コントローラはRaspberry Piに接続
        ```sh
        ros2 launch raspicat raspicat.launch.py
        ros2 service call /motor_power std_srvs/SetBool '{data: true}'
        ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
        ```
    
        #### ノートPCでの実行
        ```sh
        ros2 launch livox_ros_driver2 msg_MID360_launch.py
        ros2 launch pointcloud_to_laserscan mid360_pointcloud2_to_laserscan.launch.py
        ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
        # ~/map に保存
        ros2 run nav2_map_server map_saver_cli -f ~/map
        ```

[次のページへ進む](../8_nav){ .md-button }
