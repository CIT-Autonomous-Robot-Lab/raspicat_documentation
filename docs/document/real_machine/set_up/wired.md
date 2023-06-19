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
    source $HOME/.bashrc
    ```

    * ROS 2の設定のみ済んでいない場合（ほとんどの人はできてないと思うので実行推奨）  
    ```sh
    bash <(curl -s https://raw.githubusercontent.com/uhobeike/ros2_humble_install_script/main/ros2_setting.sh)
    ```

    #### 2. ワークスペースの構築

    * Install apt pkg  
    ```sh
    sudo apt install git python3-vcstool
    ```

    * 学校で初めてsshで`git clone`する場合は以下を実行してください
    ```sh
    curl -s https://raw.githubusercontent.com/uhobeike/ssh_config_cit/master/config >> ~/.ssh/config
    ```

    * Set Up Workspace（[GitHubでの鍵の登録が済んでいる前提](https://qiita.com/shizuma/items/2b2f873a0034839e47ce)）
    ```sh
    git clone git@github.com:CIT-Autonomous-Robot-Lab/raspicat2.git
    cd raspicat2 && mkdir src
    vcs import src < raspicat-pc.repos --debug
    rosdep update
    rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
    colcon build --symlink-install
    ```

=== "Raspberry Pi"

    ### 1. microSDカードにUbuntuのイメージを焼く

    [Ubuntu 22.04 LTSのリリースページ](http://cdimage.ubuntu.com/ubuntu/releases/22.04/release/)から**Ubuntu 22.04 server**のイメージファイル（`ubuntu-22.04.1-preinstalled-server-arm64+raspi.img.xz`）をダウンロードします。

    [ここをクリックするとダウンロードが始まります](http://cdimage.ubuntu.com/ubuntu/releases/22.04/release/ubuntu-22.04.2-preinstalled-server-armhf+raspi.img.xz){ .md-button .md-button--primary }

    ダウンロードしたイメージは[rpi-imager](https://www.raspberrypi.com/software/)等でSDカードに書き込みます。

    * rpi-imagerのインストール
    ```sh
    sudo apt install rpi-imager
    ```

    下記のコマンドを実行して`rpi-imager`を立ち上げましょう。  
    以下のようにwindowが立ち上がると思います。
    ```sh
    rpi-imager
    ```
    
    [![Image from Gyazo](https://i.gyazo.com/88d0843765391ee6299dd38936db8303.png)](https://gyazo.com/88d0843765391ee6299dd38936db8303)

    **ダウンロードしたイメージ**と**microSDカード**を選択し  
    以下のようにmicroSDカードに書き込みましょう。

    [![Image from Gyazo](https://i.gyazo.com/9157c716a1debe037a04fc3336bc695a.png)](https://gyazo.com/9157c716a1debe037a04fc3336bc695a)

    ### 2. 焼いたmicroSDカードをRaspberry Piに挿してRaspberry Pi Catを起動

    焼いたmicroSDカードをRaspberry Piに挿して、Raspberry Pi Catの電源を入れましょう。

    [![Image from Gyazo](https://i.gyazo.com/773838cb53079f918e3bcc0b457f297d.gif)](https://gyazo.com/773838cb53079f918e3bcc0b457f297d)

    ### 3. 有線LANを使用し、ノートPCのネットワークを利用する

    **ノートPC**と**Raspberry Pi**間をLANケーブルで接続し、**ノートPC**から**Raspberry Pi**へssh接続を行います。

    * **ノートPC**と**Raspberry Pi**間をLANケーブルで接続

    挿入後にそれぞれのLANポートのインジケーターランプが点滅していることを確認しましょう。

    [![Image from Gyazo](https://i.gyazo.com/cdbd2cdcffc5ebc7d87ede19a79bb445.gif)](https://gyazo.com/cdbd2cdcffc5ebc7d87ede19a79bb445)

    * ssh接続し、**Raspberry Pi**の中に入る

    