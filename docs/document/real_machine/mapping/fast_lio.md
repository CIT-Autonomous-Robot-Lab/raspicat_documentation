---
title: FAST_LIOで地図作成マニュアル
summary: LIVOX MID-360・FAST_LIOで地図作成
authors:
    - Ikuo Shige
date: 2023-09-11
---

# FAST_LIOで地図作成マニュアル

## 0. FAST_LIOについて

FAST-LIO（Fast LiDAR-Inertial Odometry）は、計算効率が高くて頑強なLiDAR-慣性オドメトリパッケージです。

LiDARの特徴点とIMUデータを緊密に結合し、高速動作、ノイズの多い環境、または雑多な環境での頑強なナビゲーションを可能にするために、反復拡張カルマンフィルタを使用している。

- オリジナル: 
<iframe class="hatenablogcard" style="width:100%;height:155px;max-width:680px;" title="%text%" src="https://hatenablog-parts.com/embed?url=https://github.com/hku-mars/FAST_LIO" width="400" height="150" frameborder="0" scrolling="no"> </iframe> 

- 使用するリポジトリ: 
<iframe class="hatenablogcard" style="width:100%;height:155px;max-width:680px;" title="%text%" src="https://hatenablog-parts.com/embed?url=https://github.com/Ericsii/FAST_LIO" width="300" height="150" frameborder="0" scrolling="no"> </iframe> 

## 1. 前提条件

- PCL >= 1.8 (テスト環境: 1.12)
- Eigen >= 3.3.4 (テスト環境: 3.4.0)

## 2. pcl_rosのインストール

```bash
sudo apt install -y ros-$ROS_DISTRO-pcl-*
```

## 3. Eigenのインストール

```bash
sudo apt install -y libeigen3-dev
```

## 4. LIVOXドライバのインストール

???+ note "LIVOX MID-360の環境構築"
    **[LIVOX MID-360 環境構築](./../set_up/livox.md)**が**全て**済んでいる場合は飛ばしてください

    <!-- ???+ LIVOXMID-360の環境構築 -->
    !!! warning 
        `FAST_LIO`とは別のワークスペースを分ける
    
    ### 4.1 新規ワークスペースの作成
    ```bash
    mkdir $HOME/livox_ws/src -p && cd $HOME/livox_ws/src
    ```

    ### 4.2 ドライバのclone

    ```bash
    git clone https://github.com/Livox-SDK/Livox-SDK2
    git clone https://github.com/Livox-SDK/livox_ros_driver2
    ```

    ### 4.3 build.sh:
    ```bash
    sed -i 's/colcon build --cmake-args -DROS_EDITION=${VERSION_ROS2} -DHUMBLE_ROS=${ROS_HUMBLE}/colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DROS_EDITION=${VERSION_ROS2} -DHUMBLE_ROS=${ROS_HUMBLE}/' $HOME/livox_ws/src/livox_ros_driver2/build.sh

    ```

    ```diff
    -    colcon build --cmake-args -DROS_EDITION=${VERSION_ROS2} -DHUMBLE_ROS=${ROS_HUMBLE}
    +    colcon build --symlink-install --cmake-args -DCMAKE_BUILD_TYPE=Release -DROS_EDITION=${VERSION_ROS2} -DHUMBLE_ROS=${ROS_HUMBLE}
    ```

    ### 4.4 hostpcとLIVOXのIPアドレスの設定

    ```bash
    sed -i "s/192.168.1.5/192.168.1.50/g" $HOME/livox_ws/src/livox_ros_driver2/config/MID360_config.json
    sed -i "s/192.168.1.12/192.168.1.119/g" $HOME/livox_ws/src/livox_ros_driver2/config/MID360_config.json
    ```

    !!! example

        **`192.168.1.50`**: 有線のプロファイルで設定したIPアドレス

        **`192.168.1.119`**: シリアル番号から取得したLIVOXのIPアドレス

    ### 4.5 build

    ```bash
    cd $HOME/livox_ws/src/Livox-SDK2/ && mkdir build && cd build
    cmake .. && make -j
    sudo make install
    cd $HOME/livox_ws/src/livox_ros_driver2/
    ./build.sh humble
    source /opt/ros/humble/setup.sh
    source $HOME/livox_ws/install/setup.bash
    ```

    ### 4.6 実行

    ```bash
    ros2 launch livox_ros_driver2 rviz_MID360_launch.py
    ros2 topic list -t
    ```

    !!! success
        `$ ros2 topic list -t` の出力
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

    <!-- ```bash
    $ mkdir -p $HOME/livox_ws/src
    $ cd $HOME/livox_ws/src
    $ git clone https://github.com/Livox-SDK/Livox-SDK2.git
    $ cd Livox-SDK2/
    $ mkdir build
    $ cd build
    $ cmake .. && make -j
    $ sudo make install
    $ cd $HOME/livox_ws/src
    $ git clone https://github.com/Livox-SDK/livox_ros_driver2
    $ cd livox_ros_driver2
    $ ./build.sh humble
    ``` -->

## 5. FAST_LIOのインストール

```bash
mkdir -p $HOME/ros2_ws/src && cd $HOME/ros2_ws/src/
git clone https://github.com/Ericsii/FAST_LIO.git
cd FAST_LIO
git submodule update --init
cd $HOME/ros2_ws/
source $HOME/livox_ws/install/setup.bash
colcon build --symlink-install --packages-select fast_lio
source $HOME/ros2_ws/install/setup.bash
```

!!! Tip
    ROS 2ワークスペースのパスは自分の環境に合わせて適宜変更してください

## 6. ビルドに失敗した場合

- CMakelists.txtのADD_COMPILE_OPTIONSを修正

```diff linenums="9"
-ADD_COMPILE_OPTIONS(-std=c++14)
+ADD_COMPILE_OPTIONS(-std=c++17)
```

## 7. 動作確認
```bash
ros2 launch livox_ros_driver2 msg_MID360_launch.py
ros2 launch fast_lio mapping.launch.py
ros2 service call /map_save std_srvs/srv/Trigger
```

!!! note
    `ros2 service call /map_save std_srvs/srv/Trigger`を実行したディレクトリに`test.pcd`という名前のファイルが保存される

!!! tip 
    **ファイルパスを変更したい場合**:

    - [`config/mid360.yaml`](https://github.com/Ericsii/FAST_LIO/blob/206855b1f9410c1e1b0e84c46053adfcd070256e/config/mid360.yaml#L3)の`map_file_path: `を変更する

    ```diff linenums="3"
    -        map_file_path: "./test.pcd"
    +        map_file_path: "<path_to_your_map_file>"
    ```



## 8. rosbagの取得

=== "rosbag record by launch file"

    ```bash
    ros2 launch livox_ros_driver2 msg_MID360_launch.py
    ros2 launch raspicat_bringup rosbag_record.launch.py rosbag_path:=$HOME/rosbag_mapping
    ```

    !!! info
        **topicを指定したい場合**
        ```bash
        ros2 launch raspicat_bringup rosbag_record.launch.py \
            rosbag_path:=$HOME/rosbag_mapping \
            topics:=/odom \
                    /point_raw \
                    /pointcloud_map \
                    /ekf_pose_with_covariance
        ```

=== "rosbag record by ros2 command"

    ```bash
    ros2 launch livox_ros_driver2 msg_MID360_launch.py
    ros2 bag record -o ${HOME}/rosbag_mapping --all
    ```

    !!! info
        **topicを指定したい場合**
        ```bash
        ros2 bag record -o ${HOME}/rosbag_mapping \
            /odom \
            /point_raw \
            /pointcloud_map \
            /ekf_pose_with_covariance
        ```

## 9. rosbagを再生して地図作成

!!! tip
    **`/livox/lidar`のtopicの型が`sensor_msgs/msg/PointCloud2`で地図作成したい場合**:

    - [`config/mid360.yaml`](https://github.com/Ericsii/FAST_LIO/blob/206855b1f9410c1e1b0e84c46053adfcd070256e/config/mid360.yaml#L12)の`lidar_type: `を変更する

    ```diff linenums="11"
            preprocess:
    -           lidar_type: 1                # 1 for Livox serials LiDAR, 2 for Velodyne LiDAR, 3 for ouster LiDAR, 4 for any other pointcloud input
    +           lidar_type: 4                # 1 for Livox serials LiDAR, 2 for Velodyne LiDAR, 3 for ouster LiDAR, 4 for any other pointcloud input
    ```
    `lidar_type: 1`だと、`/livox/lidar`のtopicの型が`livox_ros_driver2/msg/CustomMsg`となる

```bash
ros2 launch fast_lio mapping.launch.py config_path:=$HOME/ros2_ws/src/FAST_LIO/config/mid360.yaml
ros2 bag play -r 1 --clock 100 $HOME/rosbag_mapping
# rosbag再生終了後、地図を取得
ros2 service call /map_save std_srvs/srv/Trigger
```

<!-- 
## 10. 参考

<iframe class="hatenablogcard" style="width:100%;height:155px;max-width:680px;" title="%text%" src="https://hatenablog-parts.com/embed?url=https://qiita.com/porizou1/items/b7e779862ef85f4712b4" width="300" height="150" frameborder="0" scrolling="no"> </iframe> 
-->
 
