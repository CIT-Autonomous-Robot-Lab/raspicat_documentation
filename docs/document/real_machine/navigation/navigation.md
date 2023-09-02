# ナビゲーション

## 初回設定
ノート PC と Raspbeery Pi の両方で以下を実行

``` bash
echo "export ROS_DOMAIN_ID=1" >> ~/.bashrc
```

!!! info
    数字は任意だが、ノート PC 側と Raspberry Pi 側で同じ数字を指定する必要がある。

## ナビゲーション

=== "Serial LiDAR"
    Raspberry Pi で実行
    ``` bash
    ros2 launch raspicat raspicat.launch.py
    ```

    ノート PC で実行
    ``` bash
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_navigation raspicat_nav2.launch.py map:=$HOME/map.yaml
    ```

=== "Ethernet LiDAR"
    Raspberry Pi で実行
    ``` bash
    ros2 launch raspicat raspicat.launch.py urg:=ethernet
    ```

    ノート PC で実行
    ``` bash
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_navigation raspicat_nav2.launch.py map:=$HOME/map.yaml
    ```

