## 概要
Raspberry Pi Catでナビゲーションを行うための環境構築手順について説明します。

## 必要な環境 & 物
| Software         | Version                                      |     | 
| ---------------- | -------------------------------------------- | --- | 
| ノートPC         | Ubuntu 18.04 or 20.04（ROS Melodic or Noetic) |     | 
| Raspberry Pi 3B+ | Ubuntu 18.04 or 20.04（ROS Melodic or Noetic) |     | 

| Hardware            |                  | 
| ------------------- | ---------------- | 
| ノートPC            | Raspberry Pi 3B+ | 
| Raspberry Pi Cat    | SD　カード       | 
| LANケーブル         | 2D LiDAR         | 
| Joystick controller |                  | 

## 環境構築手順
ノートPCに`Ubuntu 18.04 server or 20.04 server`いずれかのLinux OSが入ってるとします。

今の所は、いちいちコマンドをいくつか実行して環境構築を行う必要がありますが、
一つのコマンドで全てが入るようなシステムを作成中です。

### 1. SDカードにubuntuのイメージを焼く
[こちらのサイト(Install Ubuntu on a Raspberry Pi)](https://ubuntu.com/download/raspberry-pi)から
Raspberry Pi用のUbuntu imageをダウンロードし、SDカードに焼きます。

バージョンは`Ubuntu 18.04 server` か `20.04 server`のimageを選択しましょう。

焼く前にSDカードはフォーマットしておく必要があります。

いよいよ焼く作業ですが、使用するツールは[rpi-imager](https://www.raspberrypi.com/software/)か
[balena Etcher](https://www.balena.io/etcher/)が良いと思います。

### 2. 焼いたSDカードをRaspberry Piに挿してRaspberry Pi Catを起動
焼いたSDカードをRaspberry Piに挿して、Raspberry Piの電源を入れましょう！

この時、非常停止ボタンを押していることを確認しましょう（安全のため）。

### 3. LANケーブルでノートPCとRaspberry Pi間で接続し、ssh接続
Raspberry Piの環境構築を行うためにはモニターやネットの設定が必要になってしまいます。

そのため、LANケーブルを使用しSSH接続を行うことで、ノートPCのネットを使用し環境構築を行うことができます。

ssh接続の方法については[こちらの記事(LANケーブルだけでraspberry pi 3のセットアップ(ubuntu編))](https://beike.hatenablog.jp/entry/raspi/LAN)
を参考にすると良いかもしれません。

### 4. ssh接続でRaspberry Piのセットアップ（デバイスドライバ、ROSインストール、ROSパッケージのBuild）
* パッケージの更新
まずはパッケージの更新をしましょう。

```sh
sudo apt update
sudo apt upgrade
```

* デバイスドライバのインストール

[RaspberryPiMouseパッケージ(rt-net/RaspberryPiMouse)](https://github.com/rt-net/RaspberryPiMouse.git)
をGitHubからクローンし、デバイスドライバのインストールスクリプトを走らせます。

インストールが上手く行くと音が鳴ると思います。
```
git clone https://github.com/rt-net/RaspberryPiMouse.git
cd RaspberryPiMouse/utils
./build_install.bash
```

* ROSのインストール

`Ubuntu 18.04 server`の場合は、[ryuichiueda/ros_setup_scripts_Ubuntu18.04_server](https://github.com/ryuichiueda/ros_setup_scripts_Ubuntu18.04_server.git)、
`Ubuntu 20.04 server`の場合は、[ryuichiueda/ros_setup_scripts_Ubuntu20.04_server](https://github.com/ryuichiueda/ros_setup_scripts_Ubuntu20.04_server.git)
をクローンしましょう。

ついでに、ビルドを行うためのツール(catkin buidl)もインストールしましょう。

```
# Ubuntu 18.04 server
git clone https://github.com/ryuichiueda/ros_setup_scripts_Ubuntu18.04_server.git
cd ros_setup_scripts_Ubuntu18.04_server
./step0.bash
./step1.bash
sudo apt install python-catkin-tools
```

```
# Ubuntu 20.04 server
git clone https://github.com/ryuichiueda/ros_setup_scripts_Ubuntu20.04_server.git
cd ros_setup_scripts_Ubuntu18.04_server
./step0.bash
./step1.bash
sudo apt-get install python3-catkin-tools
```

* ROSパッケージのクローン

ROSを使用してRaspberry Pi Catでナビゲーションを行うために必要なパッケージをインストールする。

ワークスペースを構築し、パッケージをクローン、依存パッケージのインストール、そしてパッケージのビルドを行い
ビルドしたパッケージの情報を読み込みます。

##### ワークスペースの構築
```
mkdir -p ~/raspicat_ws/src
```

##### パッケージをクローン
```
cd ~/raspicat_ws/src
git clone https://github.com/rt-net/raspicat_ros.git
git clone https://github.com/rt-net/raspicat_slam_navigation.git
git clone https://github.com/rt-net/raspicat_gamepad_controller.git
git clone https://github.com/uhobeike/raspicat_navigation.git
```

##### 依存パッケージのインストール
```
cd ~/raspicat_ws
rosdep update
rosdep install -r -y --from-paths --ignore-src ./.
```

##### パッケージのビルド
```
cd ~/raspicat_ws
catkin build
```

##### ビルドしたパッケージの情報を読み込み
```
source ~/raspicat_ws/devel/setup.bash
```

##### ビルドしたパッケージの情報の読み込みの自動化
以下のコマンドを実行した後はターミナルを開いた場合、もしくは
`source ~/.bashrc`をした場合にビルドしたパッケージの情報が読み込まれます。
```
echo "source ~/raspicat_ws/devel/setup.bash" >> ~/.bashrc
```

### 5. ノートPCにROSをインストール

`Ubuntu 18.04 desktop`の場合は、[ryuichiueda/ros_setup_scripts_Ubuntu18.04_desktop](https://github.com/ryuichiueda/ros_setup_scripts_Ubuntu18.04_desktop.git)、
`Ubuntu 20.04 desktop`の場合は、[ryuichiueda/ros_setup_scripts_Ubuntu20.04_desktop](https://github.com/ryuichiueda/ros_setup_scripts_Ubuntu20.04_desktop.git)
をクローンしましょう。

ついでに、ビルドを行うためのツール(catkin buidl)もインストールしましょう。

```
# Ubuntu 18.04 desktop
git clone https://github.com/ryuichiueda/ros_setup_scripts_Ubuntu18.04_desktop.git
cd ros_setup_scripts_Ubuntu18.04_desktop
./step0.bash
./step1.bash
sudo apt install python-catkin-tools
```

```
# Ubuntu 20.04 desktop
git clone https://github.com/ryuichiueda/ros_setup_scripts_Ubuntu20.04_desktop.git
cd ros_setup_scripts_Ubuntu20.04_desktop
./step0.bash
./step1.bash
sudo apt-get install python3-catkin-tools
```

### 6. ノートPCとRaspberry Pi間でROSの通信を行うための設定をする

LANケーブル経由で通信し、ssh接続ができる状態を想定しています。

ROSには環境変数として`ROS_HOSTNAME`と`ROS_MASTER_URI`があります。

これらをそれぞれの~/.bashrcn内に適切に記述して置くことで
相互に通信を行うことができます。

ROSの通信にはマスターという概念が存在し、
どちらかで`ros core`が立ち上がっている必要があります。

ここで例を交えて設定方法をについて紹介します。

`ip a`コマンドでノートPCのipアドレスを調べた所、`10.42.0.1`でした。
Raspberry Piは`10.42.0.12`でした。

この場合はそれそれの`.bashrc`に以下のように書く必要があります。

* ノートPC側をマスターにしたい場合
```
# .bashrc(ノートPC)
export ROS_MASTER_URI=http://10.42.0.1:11311
export ROS_HOSTNAME=10.42.0.1
```

```
# .bashrc(Raspberry Pi)
export ROS_MASTER_URI=http://10.42.0.1:11311
export ROS_HOSTNAME=10.42.0.12
```

* Raspberry Pi側をマスターにしたい場合
```
# .bashrc(ノートPC)
export ROS_MASTER_URI=http://10.42.0.12:11311
export ROS_HOSTNAME=10.42.0.1
```

```
# .bashrc(Raspberry Pi)
export ROS_MASTER_URI=http://10.42.0.12:11311
export ROS_HOSTNAME=10.42.0.12
```

設定ができたのでマスター側で`roscore`を立ち上げ

スレーブ側で`rostopic list`等のコマンドを実行し通信が出来ていることを確認しましょう。

ここで注意ですが、`.bashrc`を変更したら`source`を忘れずにしましょう