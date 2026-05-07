# ROS 2のシミュレータでRaspicatを動かそう！

## 概要

Dockerを使用し、Raspicatのシミュレータを起動、シミュレータ上でSLAM・
ナビゲーションを行うためのドキュメントです。
実機のRaspicatを動かす前に  
シミュレータで遊んで、ROS 2のSLAMやNavigationの感覚を身につけましょう。  
（事故が少なくなったり、作業効率が上がったりする効果があります。）

## シミュレータのセットアップ

* 使用するパッケージ

[CIT-Autonomous-Robot-Lab/raspicat-sim-docker](https://github.com/CIT-Autonomous-Robot-Lab/raspicat-sim-docker)

### Dockerのインストール（済んでいる人は飛ばしてください）
自分のPCにNvidia製のGPUが搭載されている場合は  
GPUありの方を実行してください。

=== "GPUあり"

    ``` sh
    sudo apt install docker.io
    sudo gpasswd -a $USER docker
    sudo apt install nvidia-container-runtime
    curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey |   sudo apt-key add -
    distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
    curl -s -L https://nvidia.github.io/nvidia-container-runtime/$distribution/nvidia-container-runtime.list |   sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
    sudo apt update
    sudo apt install nvidia-container-runtime
    service docker restart
    sudo reboot
    ```

=== "GPUなし"

    ``` sh
    sudo apt install docker.io
    sudo gpasswd -a $USER docker
    sudo reboot
    ```

### Docker Imageの作成

=== "GPUあり"

    ``` sh
    git clone https://github.com/CIT-Autonomous-Robot-Lab/raspicat-sim-docker
    cd raspicat-sim-docker/ros2-gpu
    docker build --build-arg USERNAME=$USER -t raspicat-sim:humble -f Dockerfile .
    ```

=== "GPUなし"

    ``` sh
    git clone https://github.com/CIT-Autonomous-Robot-Lab/raspicat-sim-docker
    cd raspicat-sim-docker/ros2-cpu
    docker build --build-arg USERNAME=$USER -t raspicat-sim:humble -f Dockerfile .
    ```

### GUIを使用するためにXサーバへのアクセス許可

``` sh
xhost +local:docker
```

### コンテナの立ち上げ
=== "GPUあり"

    ``` sh
    docker run --rm -it \
              -u $(id -u):$(id -g) \
              --gpus all \
              --privileged \
              --net=host \
              --ipc=host \
              --env="DISPLAY=$DISPLAY" \
              --mount type=bind,source=/dev,target=/dev \
              --mount type=bind,source=/home/$USER/.ssh,target=/home/$USER/.ssh \
              --mount type=bind,source=/home/$USER/.gitconfig,target=/home/$USER/.gitconfig \
              --mount type=bind,source=/usr/share/zoneinfo/Asia/Tokyo,target=/etc/localtime \
              --name raspicat-sim \
              raspicat-sim:humble
    ```

=== "GPUなし"

    ``` sh
    docker run --rm -it \
              -u $(id -u):$(id -g) \
              --privileged \
              --net=host \
              --ipc=host \
              --env="DISPLAY=$DISPLAY" \
              --mount type=bind,source=/dev,target=/dev \
              --mount type=bind,source=/home/$USER/.ssh,target=/home/$USER/.ssh \
              --mount type=bind,source=/home/$USER/.gitconfig,target=/home/$USER/.gitconfig \
              --mount type=bind,source=/usr/share/zoneinfo/Asia/Tokyo,target=/etc/localtime \
              --name raspicat-sim \
              raspicat-sim:humble
    ```

### ターミナルの追加
別のターミナルを開き以下を実行
```sh
docker exec -it raspicat-sim bash 
# ターミナルの抜け方 
# exit
```

## シミュレータでROS 2のナビゲーションを学ぶ

まずは単純にシミュレータのロボットをコントローラを使用して  
動かしてみましょう！  
速度指令値を与えることで、ロボットはその速度通りに動きます。

コマンドは、それぞれ別のターミナルで実行します。
[ターミナルの追加](### ターミナルの追加)を参照してください。

### Raspicatをシミュレータで動かすだけ

=== "キーボード操作"

    ``` sh
    ros2 launch raspicat_gazebo raspicat_with_iscas_museum.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=key
    ```

=== "ジョイスティックコントローラ操作"

    ``` sh
    ros2 launch raspicat_gazebo raspicat_with_iscas_museum.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
    ```

### SLAM（slam-toolbox）

ロボットが動かせるようになったら  マッピングを行います。
マッピングは、
ロボットが自律移動を行うために必要なデータを記した環境地図を作成すること
です。
今回を含む多くの場合で、障害物の配置（LiDARの点群のデータ）を記録します。

=== "キーボード操作"

    ```  sh
    ros2 launch raspicat_gazebo raspicat_with_iscas_museum.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=key
    ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
    ```


=== "ジョイスティックコントローラ操作"

    ```  sh
    ros2 launch raspicat_gazebo raspicat_with_iscas_museum.launch.py
    ros2 service call /motor_power std_srvs/SetBool '{data: true}'
    ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
    ros2 launch raspicat_slam raspicat_slam_toolbox.launch.py
    ```

* マップができたらターミナルを追加し以下のコマンドで地図を保存

```sh
ros2 run nav2_map_server map_saver_cli -f ~/map
```

* 保存した地図を確認してみましょう！（きれいな地図ができたかな？）

``` sh
eog $HOME/map.pgm
```

マッピングして、手に入れた地図を使用して  
ロボットの自律移動をやってみましょう！

### Navigation（Nav 2）
ロボットが動かなくなったときは2行目を繰り返し実行

``` sh
ros2 launch raspicat_gazebo raspicat_with_iscas_museum.launch.py
ros2 service call /motor_power std_srvs/SetBool '{data: true}'
ros2 launch raspicat_navigation raspicat_nav2.launch.py map:=$HOME/map.yaml use_sim_time:=true
```

## B3への課題

1. 
  指定された経路通りにロボットを走行させましょう！  
  `Gazeboを録画したもの`を、slackに貼り付けてください
  ![](https://i.gyazo.com/793a7f9ee6e02328820ffb8a7517287c.png)
2. 
  ロボットの動かし方がわかったら、マッピングをしましょう！  
  `保存した地図であるmap.pgm`をslackに貼り付けてください  
3. 
  作成した地図を使用して、ロボットのナビゲーションを行いましょう！  
  `1`と同様に指定された経路通りにロボットを走行させましょう！  
  `GazeboとRVizの両方を同時に録画したもの`をslackに貼り付けてください
