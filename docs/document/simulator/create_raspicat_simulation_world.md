# 地図からシミュレータ環境を作って、Raspberry Pi Cat動かそう！

## 概要
地図からGazeboのシミュレータ環境を作成し、Raspberry Pi Catを動かす方法について説明します。 

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC（Dockerインストール済み）         | Ubuntu 22.04（ROS 2 Humble) |

## パッケージのビルド＆インストール

```sh
grep -q "source $HOME/raspicat_map2gazebo_ws/install/setup.bash" ~/.bashrc || echo "source $HOME/raspicat_map2gazebo_ws/install/setup.bash" >> ~/.bashrc
mkdir -p $HOME/raspicat_map2gazebo_ws/src && cd $HOME/raspicat_map2gazebo_ws
git clone https://github.com/CIT-Autonomous-Robot-Lab/raspicat_map2gazebo.git src/raspicat_map2gazebo
vcs import src < src/raspicat_map2gazebo/raspicat_map2gazebo.repos --debug
rosdep update
rosdep install -y --from-paths src --ignore-src --rosdistro $ROS_DISTRO
colcon build --symlink-install
source $HOME/.bashrc
```

## シミュレータ環境の作成
`map_yaml`、`map_pgm`、`config_dir`は、絶対パスを入力してください。  
`world_name`、`author_name`、`email`は、任意の名前を入力してください。

```
ros2 launch raspicat_map2gazebo map2gazebo.launch.xml \
    map_yaml:=$(ros2 pkg prefix --share raspicat_map2gazebo)/config/map/map_tsudanuma_2_19.yaml \
    map_pgm:=$(ros2 pkg prefix --share raspicat_map2gazebo)/config/map/map_tsudanuma_2_19.pgm \
    config_dir:=$(ros2 pkg prefix --share raspicat_map2gazebo)/config \
    world_name:=tsudanuma_2_19 \
    author_name:=hoge \
    email:=hoge.com
```

## シミュレータ環境のチェック
**シミュレータ環境の作成**で入力した同じ`world_name`を入力してください。  
生成したモデルを読み込むために`colcon build`を実行する必要があります。
```bash
cd $HOME/raspicat_map2gazebo_ws
colcon build --symlink-install
ros2 launch raspicat_map2gazebo check_gazebo_world.launch.xml \
    world_name:=tsudanuma_2_19
```

[![Image from Gyazo](https://i.gyazo.com/e63309d74a689ba7f740d74e3c03d436.png)](https://gyazo.com/e63309d74a689ba7f740d74e3c03d436)

## シミュレータ環境の実行
* 環境の立ち上げ
```bash
cd $HOME/raspicat_map2gazebo_ws
colcon build --symlink-install
ros2 launch raspicat_map2gazebo raspicat_tsudanuma_2_19_world.launch \
    x_pose:=0.0 \
    y_pose:=0.0
```

* ジョイスティックコントローラ操作
```bash
ros2 service call /motor_power std_srvs/SetBool '{data: true}'
ros2 launch raspicat_bringup teleop.launch.py teleop:=joy
```

[![Image from Gyazo](https://i.gyazo.com/ee6f2b936329faaac3a8cc28f169c10e.png)](https://gyazo.com/ee6f2b936329faaac3a8cc28f169c10e)