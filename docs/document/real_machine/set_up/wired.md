## 概要
Raspberry Pi Catでナビゲーションを行うための環境構築手順について説明します。  
**ノートPC**とRaspberry Pi Catに搭載されている**Raspberry Pi**同士をLANケーブ  
で接続しセットアップを行います。

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |
| Raspberry Pi 3B+ | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |                  | 
| ------------------- | ---------------- | 
| ノートPC            | Raspberry Pi 4B+ | 
| Raspberry Pi Cat    | microSDカード（32GB以上が好ましい）       | 
| LANケーブル         | Joystick Controller  | 

## 環境構築手順

=== "ノートPC"
    ### 1. ROS 2のインストール
    
    * ROS 2のインストールをする場合  
    ```sh
    bash <(curl -s https://raw.githubusercontent.com/uhobeike/ros2_humble_install_script/main/install_desktop.sh)
    ```

    * ROS 2の設定のみ済んでいない場合（ほとんどの人はできてないと思うので実行推奨）  
    ```sh
    bash <(curl -s https://raw.githubusercontent.com/uhobeike/ros2_humble_install_script/main/ros2_setting.sh)
    ```

    #### 2. ワークスペースの構築

    * Install vsctool  
    ```sh
    sudo apt install python3-vcstool
    ```

    * Set Up Workspace  
    ```sh
    git clone git@github.com:CIT-Autonomous-Robot-Lab/raspicat2.git
    cd raspicat2 && mkdir src
    vcs import src < raspicat-pc.repos --debug
    rosdep update
    rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
    colcon build --symlink-install
    ```

=== "Raspberry Pi"
    [Ubuntu 22.04 LTSのリリースページ](http://cdimage.ubuntu.com/ubuntu/releases/22.04/release/)から**Ubuntu 22.04 server**のイメージファイル（`ubuntu-22.04.1-preinstalled-server-arm64+raspi.img.xz`）をダウンロードします。

    ダウンロードしたイメージは[rpi-imager](https://www.raspberrypi.com/software/)等でSDカードに書き込みます。