## 概要
Raspberry Pi Catでナビゲーションを行うための
ノートPCの環境構築手順について説明します。  

### 前提
Linux（Ubuntu）のネイティブの環境が必要です。
（Windows上で動くUbuntuはWSL環境です。余程の物好きでない限りWSL環境でセットアップするのは止めましょう。）
基本的には、デュアルブートを行うことになります。
デュアルブートの手順の概略のみ掲載しますが、__詳しくはご自身で調べてください。__

* BitLockerの解除
* Secure Bootの解除
* SSDの容量の確保
* インストールメディアの作成


## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |
| ------------------- |
| ノートPC            |

## 環境構築手順
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

