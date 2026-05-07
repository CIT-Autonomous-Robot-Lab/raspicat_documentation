# 6 コントローラ操作

## 概要
実機のRaspberry Pi Catをコントローラによって操作する方法を説明します。
予め[PCの設定](../1_laptopsetup)、[Raspberry Piの設定](../3_raspisetup)
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
| （LANケーブル） |
| （Joystick Controller）       | 

## コントローラで操作

#### Raspberry Piのみで実行する場合  
Raspberry Piの場合、serverのイメージを使用しているため  
GUIが使えないので、ジョイスティックコントローラのみです。

=== "ジョイスティックコントローラ"
    コントローラはRaspberry Piに接続
    ```sh
    ros2 launch raspicat raspicat.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
    ```

#### ノートPCから操作する場合

=== "キーボード"
    ```sh
    # Raspberry Pi
    ros2 launch raspicat raspicat.launch.py
    ```
    ```sh
    # PC
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=key
    ```

=== "ジョイスティックコントローラ"
    コントローラはPCに接続
    ```sh
    # Raspberry Pi
    ros2 launch raspicat raspicat.launch.py
    ```
    ```sh
    # PC
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
    ```
