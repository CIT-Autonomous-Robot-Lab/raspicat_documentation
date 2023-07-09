## 概要
実機のRaspberry Pi Catをコントローラによって操作します。  
[Set Up/有線LAN（Ethernet）](../set_up/wired.md)で、各設定が済んでいる前提で説明をします。

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |
| Raspberry Pi Cat（Raspberry Pi 4B+） | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |                  | 
| ------------------- | ---------------- | 
| ノートPC            | Raspberry Pi Cat（Raspberry Pi 4B+） | 
| LANケーブル | Joystick Controller       | 

## コントローラで操作

#### Raspberry Piの場合  
Raspberry Piの場合、serverのイメージを使用しているため  
GUIが使えないので、ジョイスティックコントローラのみです。

=== "ジョイスティックコントローラ"
    ```sh
    ros2 launch raspicat_bringup raspicat.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
    ```

#### ノートPCの場合

=== "キーボード"
    ```sh
    ros2 launch raspicat_bringup raspicat.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=key
    ```

=== "ジョイスティックコントローラ"
    ```sh
    ros2 launch raspicat_bringup raspicat.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
    ```