---
title: LIVOX MID-360 マニュアル
summary: LIVOX MID-360 の環境構築まとめです。
authors:
    - Ikuo Shige
date: 2023-09-10
---

# LIVOX MID-360 マニュアル

## 0. LIVOX MID-360 について

[LIVOX MID-360](https://www.livoxtech.com/jp/mid-360)

- 40mレンジの3D LiDAR
- 視野角: 360° x 59°(仰角)
- 最短測定距離: 10cm
- 慣性計測ユニット(Inertial Measurement Unit)搭載


## 1. 有線のプロファイル作成

- IPv4 メソッド: 手動
- IPv6 メソッド: 無効

| 名前 | アドレス | ネットマスク | ゲートウェイ | DNS(自動でない) |
| :----: | :----: | :----: | :----: | :----: |
| livox-host | 192.168.1.50 | 255.255.255.0 | 192.168.1.1 | 192.168.1.1 |

以下のスクリプトを実行することで、設定できる
```bash
#!/bin/bash

# ip linkコマンドの出力を取得
ip_output=$(ip link)

# ネットワークインターフェース名の抽出
interface_name=$(echo "$ip_output" | grep -oP '(?<=^\d: )[^\:]+')
IFS=" " read -ra interface_array <<< "$(echo "$interface_name" | awk 'NR==2')"

echo "ネットワークインターフェース名: ${interface_array[0]}"

sudo nmcli connection add \
  con-name livox-test \
  ifname ${interface_array[0]} \
  type ethernet \
  ipv4.method manual \
  ipv4.address 192.168.1.50/24 \
  ipv4.gateway 192.168.1.1 \
  ipv6.method disabled \
  ipv4.dns 192.168.1.1

nmcli connection up livox-test
```

## 2. IPアドレス確認

- IPアドレス: 192.168.1.1XX (XXはシリアル番号の末尾2桁)
- シリアル番号はLIVOXのケーブルのメス端子付近のシールに記載されている
    - シールのQRコードを読み込むことでも取得可能

!!! example
    以降はIPアドレス: **`192.168.1.119`** とする

LIVOX MID-360 と接続できるか確認
```bash
ping 192.168.1.119
```

## 3. 動作確認

<!-- 3.4はタブで分ける -->

=== "ROSなし動作確認"

    <!-- ## 3. ROSなし動作確認 -->

    !!! note
        cloneする場所は `ROS 2: Humble動作確認` と揃えているが、別の場所でも問題ない
    
    ### 3.1 clone
    ```bash
    mkdir -p $HOME/livox_ws/src
    cd $HOME/livox_ws/src
    git clone https://github.com/Livox-SDK/Livox-SDK2
    ```

    ### 3.2 build
    ```bash
    cd $HOME/livox/src/Livox-SDK2/ && mkdir build && cd build
    cmake .. && make -j
    sudo make install
    ```

    ### 3.3 `host_ip`の設定
    ```bash
    sed -i "s/192.168.1.5/192.168.1.50/g" $HOME/livox_ws/src/Livox-SDK2/samples/livox_lidar_quick_start/mid360l_config.json
    ```

    ### 3.4 実行
    ```bash
    cd $HOME/livox_ws/src/Livox-SDK2/build/samples/livox_lidar_quick_start/
    ./livox_lidar_quick_start ../../../samples/livox_lidar_quick_start/mid360_config.json
    ```

===+ "ROS 2: Humble動作確認"

    <!-- ## 4. ROS 2: Humble動作確認 -->


    !!! warning
        `FAST_LIO`とは別のワークスペースを分ける
    ### 3.1 新規ワークスペースの作成

    ```bash
    mkdir $HOME/livox_ws/src -p && cd $HOME/livox_ws/src
    ```

    ### 3.2 ドライバのclone

    ```bash
    git clone https://github.com/Livox-SDK/livox_ros_driver2
    ```

    ### 3.3 build.sh:61行目の変更

    ```diff linenums="61"
    -    colcon build --cmake-args -DROS_EDITION=${VERSION_ROS2} -DHUMBLE_ROS=${ROS_HUMBLE}
    +    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DROS_EDITION=${VERSION_ROS2} -DHUMBLE_ROS=${ROS_HUMBLE}
    ```

    ### 3.4 hostpcとLIVOXのIPアドレスの設定

    ```bash
    sed -i "s/192.168.1.5/192.168.1.50/g" $HOME/livox_ros_driver2/config/MID360_config.json
    sed -i "s/192.168.1.12/192.168.1.119/g" $HOME/livox_ros_driver2/config/MID360_config.json
    ```

    ### 3.5 build

    ```bash
    source $HOME/livox_ws/install/setup.bash
    cd $HOME/livox_ws/src/livox_ros_driver2
    ./build.sh humble
    ```

    ### 3.6 実行

    ```bash
    ros2 launch livox_ros_driver2 rviz_MID360_launch.py
    ros2 topic list -t
    ```

    !!! success
        `ros2 topic list -t` の出力
        ```bash
        /clicked_point [geometry_msgs/msg/PointStamped]
        /initialpose [geometry_msgs/msg/PoseWithCovarianceStamped]
        /livox/imu [sensor_msgs/msg/Imu]
        /livox/lidar [sensor_msgs/msg/PointCloud2]
        /move_base_simple/goal [geometry_msgs/msg/PoseStamped]
        /parameter_events [rcl_interfaces/msg/ParameterEvent]
        /rosout [rcl_interfaces/msg/Log]
        /tf [tf2_msgs/msg/TFMessage]
        /tf_static [tf2_msgs/msg/TFMessage]
        ```

<!-- 
## 4. 参考

<iframe class="hatenablogcard" style="width:100%;height:155px;max-width:680px;" title="%text%" src="https://hatenablog-parts.com/embed?url=https://proc-cpuinfo.fixstars.com/2023/01/livox-mid360-ros1-ros2/" width="300" height="150" frameborder="0" scrolling="no"> </iframe> 
<iframe class="hatenablogcard" style="width:100%;height:155px;max-width:680px;" title="%text%" src="https://hatenablog-parts.com/embed?url=https://github.com/Livox-SDK/Livox-SDK2/" width="300" height="150" frameborder="0" scrolling="no"> </iframe> 
<iframe class="hatenablogcard" style="width:100%;height:155px;max-width:680px;" title="%text%" src="https://hatenablog-parts.com/embed?url=https://github.com/Livox-SDK/livox_ros_driver2" width="300" height="150" frameborder="0" scrolling="no"> </iframe> 
-->
