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
| Joystick Controller  | microSDカード（32GB以上が好ましい）       | 
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
    sudo apt install -y git python3-vcstool xterm
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

    ### 3. 時刻同期のための設定

    * Run script
    ```sh
    colcon_cd raspicat_setup_scripts
    ./time_synchronization/scripts/setup_remote_pc.sh
    ```

=== "Raspberry Pi"

    ### 1. microSDカードにUbuntuのイメージを焼く  

    * イメージのダウンロード  
    [Ubuntu 22.04 LTSのリリースページ](http://cdimage.ubuntu.com/ubuntu/releases/22.04/release/)から**Ubuntu 22.04 server**のイメージファイル  
    （`ubuntu-22.04.1-preinstalled-server-arm64+raspi.img.xz`）をダウンロードします。  
    [ここをクリックするとダウンロードが始まります](http://cdimage.ubuntu.com/ubuntu/releases/22.04/release/ubuntu-22.04.3-preinstalled-server-arm64+raspi.img.xz){ .md-button .md-button--primary } 

    ダウンロードしたイメージは[rpi-imager](https://www.raspberrypi.com/software/)等でSDカードに書き込みます。

    * rpi-imagerのインストール
    ```sh
    sudo apt install -y rpi-imager
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

    !!! Warning
        「詳細な設定」はすべてオフにしてください。
        ここで「ホスト名」や「ユーザ名」を設定すると、この後デバイスドライバをインストールする際にエラーが発生します。

    ### 2. 焼いたmicroSDカードをRaspberry Piに挿してRaspberry Pi Catを起動

    * Raspberry Pi Catの起動  
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
    
    * network-managerのインストール  
    ```sh
    sudo apt install -y network-manager
    ```
    ```sh
    export ET_NIC_NAME=$(ip -o link show | awk -F': ' '$2 ~ /^en[opsx]/ {print $2}')
    export PROFILE_NAME=raspicat
    nmcli connection add type ethernet con-name $PROFILE_NAME ifname $ET_NIC_NAME ipv4.method shared
    ```
    
    3 . プロファイルを作成後、プロファイルの適用を行います  

    * プロファイルの適用  
    ```sh
    nmcli con up $PROFILE_NAME ifname $ET_NIC_NAME
    ```

    4 . `ip a`で有線LAN接続ができているか確認します  
    
    * 有線LAN接続の確認  
    **enp0s31f6**のIPアドレスが`10.42.0.1`になっていれば問題ないです。  
    人によっては、**eno**、**enp**、**ens**、**enx**になっています。（[命名規則について](https://www.thomas-krenn.com/en/wiki/Predictable_Network_Interface_Names)）
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

    * arp-scanのインストール  
    Raspberry PiのIPアドレスを調べるために`arp-scan`コマンドを使用します。
    ```sh
    sudo apt install -y arp-scan
    ```
    * ssh接続  
    Raspberry PiのIPアドレスを調べ、そのIPを使用しssh接続を行います。  
    ```sh
    export Raspberry_Pi_IP=$(sudo arp-scan -l -I $ET_NIC_NAME | awk 'NR==3{print $1}')
    ssh ubuntu@$Raspberry_Pi_IP
    ```

    * 接続すると**yes**か**no**かを求められます  
    yesを選択しましょう。

    * 次にパスワードを求められます  
    デフォルトのパスワードは`ubuntu`です。  
    そのため、以下のように入力を求められたら、`ubuntu`と打ちましょう。
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
    
    * パスワード無しでssh接続  
    ```sh
    ssh-copy-id ubuntu@$Raspberry_Pi_IP
    ssh ubuntu@$Raspberry_Pi_IP
    ```

    6 . ssh接続ができたら、**Raspberry Pi**がPCのネットワークを利用できているか確認します  
    
    * ネットワークへの接続確認（**Raspberry Pi**）
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
  
        <span style="font-size: 200%; color: red;">↓**ノートPC上**で下記のコマンドを実行してください↓</span>
        
        ```sh 
        export ET_NIC_NAME=$(ip -o link show | awk -F': ' '$2 ~ /^en[opsx]/ {print $2}')
        export WL_NIC_NAME=$(ip -o link show | awk -F': ' '$2 ~ /^wl[opsx]/ {print $2}')
        sudo iptables -t nat -A POSTROUTING -o $WL_NIC_NAME -j MASQUERADE
        sudo iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
        sudo iptables -A FORWARD -i $ET_NIC_NAME -o $WL_NIC_NAME -j ACCEPT
        ```
    
    ### 4. aptパッケージのアップグレード

    * aptパッケージの自動更新をオフにする  
    aptパッケージを更新する際に、自動更新のプロセスが邪魔をしてくるので、オフにしましょう。
    ```sh
    sudo systemctl stop unattended-upgrades
    sudo apt purge unattended-upgrades
    sudo pkill --signal SIGKILL unattended-upgrades
    ```

    * aptパッケージの更新（時刻同期）  
    正常にaptパッケージの更新をするには、時刻を正しくする必要があります。  
    `date`コマンドを打つと、現在の時刻ではないことが分かります。  
    ```sh
    wget -O /tmp/setup_raspi.sh --no-check-certificate https://raw.githubusercontent.com/CIT-Autonomous-Robot-Lab/raspicat_setup_scripts/ros2/time_synchronization/scripts/setup_raspi.sh
    chmod +x /tmp/setup_raspi.sh
    . /tmp/setup_raspi.sh
    ```
    <span style="font-size: 150%; color: red;">↓**ノートPC上**で下記のコマンドを実行してください↓</span>
    ```sh
    sudo systemctl restart chrony.service
    ```
    !!! info 
        上記のコマンドでは、ノートPC（サーバ）の時間が合っているものとしています。    
        その上で、Raspberry Pi（クライアント）は、ノートPCの時刻を参照し、時刻の更新をします。
    * aptパッケージの更新  
    ```sh
    sudo apt update -y
    sudo apt upgrade -y
    ```
    ここで一旦、Raspberry Piの**再起動**を行います。
    ```sh
    sudo reboot
    ```
    20秒程経ったら、再度ssh接続を行いましょう。
    ```sh
    ssh ubuntu@$Raspberry_Pi_IP
    ```

    ### 5. ROS 2のインストール

    * Install ROS 2
    ```sh
    bash <(curl -s https://raw.githubusercontent.com/uhobeike/ros2_humble_install_script/main/install_server.sh)
    source $HOME/.bashrc
    ```

    ### 6. ワークスペースの構築

    * Install apt pkg  
    ```sh
    sudo apt install -y build-essential git python3-vcstool
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
    vcs import src < raspicat-raspi.repos --debug
    rosdep update
    rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
    colcon build --symlink-install
    source $HOME/.bashrc
    ```

    ### 7. デバイスドライバのインストール

    Raspberry Pi CatをROS 2で制御するには、デバイスドライバのインストールが必要です。

    * Install Device Driver
    ```sh
    colcon_cd raspicat_setup_scripts
    ./device_driver_auto_install/scripts/install.sh
    ```

    !!! info
        デバイスドライバは、特定のハードウェアデバイスとOS間で通信を行うためのソフトウェアです。

