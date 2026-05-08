## 概要
Raspberry Pi Catでナビゲーションをする方法について説明します。 
予め[PCの設定](../1_laptopsetup)、[Raspberry Piの設定](../3_raspisetup)、
（LIVOX MID-360を使用する場合は、[無線接続設定](../4_wireless)、[MID360の接続設定](../5_livox)）
を完了してからこちらに進んでください。

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |
| Raspberry Pi Cat（Raspberry Pi 4B+） | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |                  | 
| ------------------- | ---------------- | 
| ノートPC            | Raspberry Pi Cat（Raspberry Pi 4B+） | 
| LANケーブル（有線通信の場合） | 2D LiDAR（[北陽](https://www.hokuyo-aut.co.jp/search/?cate01=1)） | 

## 初回設定
ノートPCと Raspbeery Piの両方で以下を実行

``` bash
echo "export ROS_DOMAIN_ID=1" >> ~/.bashrc
source ~/.bashrc
```

!!! info
    数字は任意ですが、ノートPC側と Raspberry Pi側で同じ数字の[ROS_DOMAIN_ID](https://docs.ros.org/en/dashing/Concepts/About-Domain-ID.html)を設定する必要があります。設定できる数字は、0〜232です。

## ナビゲーション

=== "Serial LiDAR"
    Raspberry Piで実行
    ``` bash
    ros2 launch raspicat raspicat.launch.py
    ```

    ノートPCで実行
    ``` bash
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_navigation raspicat_nav2.launch.py map:=$HOME/map.yaml
    ```

=== "Ethernet LiDAR"
    Raspberry Piで実行
    ``` bash
    ros2 launch raspicat raspicat.launch.py urg:=ethernet
    ```

    ノートPCで実行
    ``` bash
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_navigation raspicat_nav2.launch.py map:=$HOME/map.yaml
    ```

=== "LIVOX LiDAR"
    Raspberry Piで実行
    ``` bash
    ros2 launch raspicat raspicat.launch.py
    ```

    ノートPCで実行
    ``` bash
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch livox_ros_driver2 msg_MID360_launch.py
    ros2 launch pointcloud_to_laserscan mid360_pointcloud2_to_laserscan.launch.py
    ros2 launch raspicat_navigation raspicat_nav2.launch.py map:=$HOME/map.yaml
    ```

[次のページへ進む](../9_navwithemcl){ .md-button }
