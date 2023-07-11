## 概要
Raspberry Pi Catで地図作成をする方法について説明します。 
[Set Up/有線LAN（Ethernet）](../set_up/wired.md)および[Set Up/無線LAN（Wi-Fi）](../set_up/wireless.md)で、各設定が済んでいる前提で説明をします。

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |
| Raspberry Pi Cat（Raspberry Pi 4B+） | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |                  | 
| ------------------- | ---------------- | 
| ノートPC            | Raspberry Pi Cat（Raspberry Pi 4B+） | 
| LANケーブル（有線通信の場合） | 2D LiDAR（[北陽](https://www.hokuyo-aut.co.jp/search/?cate01=1)） | 
| Joystick Controller |  |

## 地図作成（マッピング）

=== "Offline Mapping"

    #### Raspberry Piでの実行

    ```sh
    ros2 launch raspicat raspicat.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=joy

    # 全トピックを取得したい場合
    ros2 launch raspicat_bringup rosbag_record.launch.py rosbag_path:=$HOME/rosbag_mapping

    # 特定のトピックのみを取得したい場合
    ros2 launch raspicat_bringup rosbag_record.launch.py rosbag_path:=$HOME/rosbag_mapping topics:=/odom /scan /tf /tf_static
    ```

    #### ノートPCでの実行

    ```sh
    # 取得したrosbagをノートPCに移動（有線接続の場合）
    sudo scp -r $HOME/rosbag_mapping ubuntu@10.42.0.1:$HOME

    ros2 bag play -r 1 --clock 100 $HOME/rosbag_mapping
    ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
    ```

=== "Online Mapping"

    #### Raspberry Piでの実行

    ```sh
    ros2 launch raspicat raspicat.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
    ```

    #### ノートPCでの実行
    ```sh
    ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
    ```
