## 概要
Raspberry Pi Catでナビゲーションを行うための環境構築手順について説明します。  
**ノートPC**とRaspberry Pi Catに搭載されている**Raspberry Pi**同士をLANケーブ  
で接続しセットアップを行います。

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |
| Raspberry Pi Cat（Raspberry Pi 4B+） | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |                  | 
| ------------------- | ---------------- | 
| ノートPC            | Raspberry Pi Cat（Raspberry Pi 4B+） | 
|   Joystick Controller  | microSDカード（32GB以上が好ましい）       | 
| LANケーブル         |   | 

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

    ### 2. ワークスペースの構築

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
    git clone git@github.com:CIT-Autonomous-Robot-Lab/raspicat2.git $HOME/raspicat2
    grep -q "source $HOME/raspicat2/install/setup.bash" ~/.bashrc || echo "source $HOME/raspicat2/install/setup.bash" >> ~/.bashrc
    grep -q "export RASPICAT2_WS=$HOME/raspicat2" ~/.bashrc || echo "export RASPICAT2_WS=$HOME/raspicat2" >> ~/.bashrc
    source $HOME/.bashrc
    cd $RASPICAT2_WS && mkdir src
    vcs import src < raspicat-pc.repos --debug
    rosdep update
    rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
    colcon build --symlink-install
    source $HOME/.bashrc
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

    !!! Warning
        **ノートPC**は**Wi-Fi**に接続している必要があります。

    1 . **ノートPC**と**Raspberry Pi**間をLANケーブルで接続

    挿入後にそれぞれのLANポートのインジケーターランプが点滅していることを確認しましょう。

    [![Image from Gyazo](https://i.gyazo.com/cdbd2cdcffc5ebc7d87ede19a79bb445.gif)](https://gyazo.com/cdbd2cdcffc5ebc7d87ede19a79bb445)

    2 . PC側でEthernetの接続プロファイルを作成します  
    `PROFILE-NAME`は任意の名前、`NIC-NAME`は`ip`コマンド等で調べたEthernetのインターフェイス名です。
    
    * network-managerのインストール

    ```sh
    sudo apt install network-manager
    ```

    ```sh
    export ET_NIC_NAME=$(ip -o link show | awk -F': ' '$2 ~ /^enp/ {print $2}')
    export PROFILE_NAME=raspicat
    nmcli connection add type ethernet con-name $PROFILE_NAME ifname $ET_NIC_NAME ipv4.method shared
    ```
    
    3 . プロファイルを作成後、プロファイルの適用を行います  
    `PROFILE-NAME`には、作成したプロファイル名を入れます。
    
    ```sh
    nmcli con up $PROFILE_NAME ifname $ET_NIC_NAME
    ```

    4 . `ip a`で有線LAN接続ができているか確認します  

    enp0s31f6のIPアドレスが10.42.0.1になっていれば問題ないです。

    ```sh hl_lines="10"
    ikebe@ikebe:~$ ip a
    1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
        link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
        inet 127.0.0.1/8 scope host lo
          valid_lft forever preferred_lft forever
        inet6 ::1/128 scope host 
          valid_lft forever preferred_lft forever
    2: enp0s31f6: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc fq_codel state UP group default qlen 1000
        link/ether f8:75:a4:a9:0a:49 brd ff:ff:ff:ff:ff:ff
        inet 10.42.0.1/24 brd 10.42.0.255 scope global noprefixroute enp0s31f6
          valid_lft forever preferred_lft forever
        inet6 fe80::ec73:35a8:7a39:dcfc/64 scope link noprefixroute 
          valid_lft forever preferred_lft forever
    3: wlp0s20f3: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default qlen 1000
        link/ether 80:32:53:62:73:c5 brd ff:ff:ff:ff:ff:ff
        inet 192.168.23.232/24 brd 192.168.23.255 scope global dynamic noprefixroute wlp0s20f3
          valid_lft 84272sec preferred_lft 84272sec
        inet6 fe80::5c7a:7a80:7622:ed41/64 scope link noprefixroute 
          valid_lft forever preferred_lft forever
    ```
    
    5 . Raspberry Piにssh接続  
    Raspberry PiのIPアドレスを調べるために`arp-scan`コマンドを使用します。
    ```sh
    sudo apt install arp-scan
    sudo arp-scan -l -I $ET_NIC_NAME
    ```
    Raspberry PiのIPアドレスを調べ、そのIPを使用しssh接続を行います。  
    ```sh
    export Raspberry_Pi_IP=$(sudo arp-scan -l | awk 'NR==3{print $1}')
    ssh ubuntu@$Raspberry_Pi_IP
    ```

    * 接続すると**yes**か**no**かを求められます  
    yesを選択しましょう。

    * 次にパスワードを求められます  
    デフォルトのパスワードは`ubuntu`です。
    
    なので以下のように入力を求められたら、`ubuntu`と打ちましょう。
    ```sh
    ubuntu@10.42.0.13's password: 
    ```

    * 今度はパスワードの変更を求められます

    以下のように入力を求められたら、  
    現在のパスワードを聞かれているので`ubuntu`と入力します。
    ```sh
    Current password:
    ```

    次の入力では、設定したい自分が考えたパスワードを打ち込みます。

    パスワードをうまく設定できたら、以下のように出力されます。
    ```sh
    passwd: password updated successfully
    Connection to 10.42.0.13 closed.
    ```
    **接続が閉じられるので再度sshをする必要があります。**  
    
    6 . ssh接続ができたら、Raspberry PiがPCのネットワークを利用できているか確認します  
    ```sh
    ping '8.8.8.8'
    ```

    !!! info 
        実行後の正常な出力結果は以下のとおりです。  
        ```sh hl_lines="2 3 4"
        $ ping '8.8.8.8'
        PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
        64 bytes from 8.8.8.8: icmp_seq=1 ttl=110 time=91.2 ms
        64 bytes from 8.8.8.8: icmp_seq=2 ttl=110 time=38.5 ms
                            （以下省略）
        ```

    !!! Warning
        **ノートPC**が**Wi-Fi**に接続されている状態で、下記のように結果が何も返ってこない場合は  
        ```sh hl_lines="2"
        $ ping '8.8.8.8'
        PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
        ```
        **ノートPC**上で下記のコマンドを実行してください。
        ```sh 
        export ET_NIC_NAME=$(ip -o link show | awk -F': ' '$2 ~ /^enp/ {print $2}')
        export WL_NIC_NAME=$(ip -o link show | awk -F': ' '$2 ~ /^wlp/ {print $2}')
        sudo iptables -t nat -A POSTROUTING -o $WL_NIC_NAME -j MASQUERADE
        sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
        sudo iptables -A FORWARD -i $ET_NIC_NAME -o $WL_NIC_NAME -j ACCEPT
        ```
    
    ### 4. aptパッケージのアップグレード
    焼いたばかりのイメージの中のaptパッケージは最新ではないです。  
    最新にしましょう。

    * 正常にインストールするには時刻を正しくしておく必要があります
    おそらく`date`コマンドを打つと現在の時刻ではないと思われます。  
    そのため、`date`コマンドで修正しましょう。  
    以下のコマンドは修正例です。

    ```sh
    sudo date -s "2023/6/24 22:54:53"
    ```

    時刻を修正できたのでアップグレード開始

    ```sh
    sudo apt update
    sudo apt upgrade
    ```

    ### 5. ROS 2のインストール

    ```sh
    bash <(curl -s https://raw.githubusercontent.com/uhobeike/ros2_humble_install_script/main/install_server.sh)
    source $HOME/.bashrc
    ```

    ### 6. ワークスペースの構築

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
    git clone git@github.com:CIT-Autonomous-Robot-Lab/raspicat2.git $HOME/raspicat2
    grep -q "source $HOME/raspicat2/install/setup.bash" ~/.bashrc || echo "source $HOME/raspicat2/install/setup.bash" >> ~/.bashrc
    grep -q "export RASPICAT2_WS=$HOME/raspicat2" ~/.bashrc || echo "export RASPICAT2_WS=$HOME/raspicat2" >> ~/.bashrc
    cd $RASPICAT2_WS && mkdir src
    vcs import src < raspicat-raspi.repos --debug
    rosdep update
    rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
    colcon build --symlink-install
    source $HOME/.bashrc
    ```

    ### 7. デバイスドライバのインストール

    Raspberry Pi CatをROS 2で制御するには、デバイスドライバのインストールが必要です。
    
    !!! info
        デバイスドライバは、特定のハードウェアデバイスとOS間で通信を行うためのソフトウェアです。

    ```sh
    colcon_cd raspicat_setup_scripts
    ./device_driver_auto_install/scripts/install.sh
    ```