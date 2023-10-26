## 概要
Raspberry Pi Catを[emcl2_ros2](https://github.com/cit-autonomous-robot-lab/emcl2_ros2)で自己位置推定させる方法

## 環境構築手順
### パッケージの準備
#### raspicat_slam_navigation
emcl2_ros2を起動するブランチに切り替える。
``` bash
cd ~/raspicat2/src/raspicat_slam_navigation
git checkout -b feat/emcl2-ros2 origin/feat/emcl2-ros2
```
#### emcl2_ros2
肝心の[emcl2_ros2](https://github.com/cit-autonomous-robot-lab/emcl2_ros2)パッケージをクローンする。
``` bash
cd ~/raspicat2/src
git clone https://github.com/cit-autonomous-robot-lab/emcl2_ros2
```

### ビルド
``` bash
cd ~/raspicat2
colcon build --symlink-install --packages-select raspicat_navigation emcl2
source install/setup.bash
```

## 動作確認
### launchファイルを実行
``` bash
ros2 launch raspicat_navigation raspicat_nav2.launch.py
```

### `/emcl2`ノードが立ち上がったことを確認
`/amcl`ノードが立ち上がっていないことも確認
``` bash
ros2 node list
```

## amclに戻したい場合
### ブランチをデフォルト`ros2`に戻す
``` bash
cd ~/raspicat2/src/raspicat_slam_navigation
git checkout ros2
```

### ビルド
``` bash
cd ~/raspicat2
colcon build --symlink-install --packages-select raspicat_navigation
```

