# オンラインmappingをしてみよう！

## 概要
Raspberry Pi Catで**オンラインマッピング(SLAM)**を行う方法を説明します。

## 必要な物

Raspberry Pi側に2D LiDARが接続されている想定で進めてきます。

2D LiDARの電源はポータブル電源から取ります。

Raspberry Pi動作時に電源を取る時は**ショート**に気を付けましょう。

| Hardware            |                  | 
| ------------------- | ---------------- | 
| Raspberry Pi Cat    | ノートPC         | 
| LANケーブル         | 2D LiDAR（遠くまで見れるかつデータにノイズが少ないものが良い）         | 
| Joystick controller |                  | 

## 実行コマンド

今回はraspi側がマスターであることを想定して進めていきます。

↓マスター側は始めにroscoreを立ち上げる必要がありますが、
roslaunchを立ち上げるとroscoreが立ち上がっていない場合に立ち上げてくれる仕組みになってるので、
あえてroscoreを書いていません。

### 無線Joystick controllerを使用する場合

```
# Raspberry Pi 3B+
roslaunch raspicat raspicat.launch
roslaunch raspicat_slam_navigation slam_remote_robot_usb_urg.launch
```

```
# ノートPC
roslaunch raspicat_slam_navigation slam_remote_pc.launch
```

```
# ノートPC（マッピング完了後）
rosrun map_servser map_saver -f ~/map
```

### 有線Joystick controllerを使用する場合

事前に[この部分](https://github.com/CIT-Autonomous-Robot-Lab/raspicat_slam/blob/bb49278db7d7af30aa1d046f30093304857f4813/launch/slam_remote_robot_usb_urg.launch#L6-L9)
を削除しておく必要があるので削除orコメントアウトをしましょう。(ノートPC側でJoystick controllerを使用したいので。無線の場合は削除しなくても大丈夫です。)

```
# Raspberry Pi 3B+
roslaunch raspicat raspicat.launch
roslaunch raspicat_slam_navigation slam_remote_robot_usb_urg.launch
```

```
# ノートPC
roslaunch raspicat_gamepad_controller logicool.launch
roslaunch raspicat_slam_navigation slam_remote_pc.launch
```

```
# ノートPC（マッピング完了後）
rosrun map_servser map_saver -f ~/map
```

## マッピングのコツ？

* マッピング側の気持ちになりましょう？！

何を言ってるんだ！よく分からんと思った方もいるでしょう。
ですがコレは必要なことだと思います。マッピング側のアルゴリズムを考えながらマッピングすることで
こんな感じにJoystick controllerを操作すれば良いんだよな、パラメータはこれが良いよなと
考えるようになります。

最初はわからないと思うので、とりあえず動かしまくりましょう。

必ず良いマップが出来上がるわけではなく、
**歪んだマップ**が生成されてしまう場合もあります。

良いマッピングをするためには**試行錯誤**と**ネットでの調査(パラメータ・アルゴリズム)**が物を言います。

## 参考資料

* Gmappingのパラメータについて

[roswikiを見るとパラメータやトピックについての情報](http://wiki.ros.org/gmapping)
が書かれているので参考にしましょう。(英語だと読めない方は日本語訳をすると良いです。)



* 調整したパラメータ

つくばチャレンジで良いマップを生成するために修正したパラメータは[こちら](https://github.com/CIT-Autonomous-Robot-Lab/raspicat_slam/blob/bb49278db7d7af30aa1d046f30093304857f4813/launch/slam_remote_pc.launch#L12-L34)です。

## 応用編！！?

応用編と言いながら実行コマンド等は書かかず文だけでお話します。

そろそろ新しいパッケージがリリースされるので、その時は実行コマンドを書きます。

Raspberry Pi Catでは`Gmapping`を主に使用していますが、世の中には色々なSLAMのアルゴリズムがあり色々なSLAMパッケージが
存在します。もちろん`Gmapping`より効果的なパッケージも存在するので、ぜひ色々なSLAMを動かしてみると良いと思います。

### 代表的なSLAMパッケージ（2D SLAM）

#### ・[ros-perception/slam_gmapping](https://github.com/ros-perception/slam_gmapping)

#### ・[cartographer-project/cartographer_ros](https://github.com/cartographer-project/cartographer_ros)

#### ・[SteveMacenski/slam_toolbox](https://github.com/SteveMacenski/slam_toolbox)

色々なSLAMについてまとめられている[サイト](https://qiita.com/rsasaki0109/items/493c1059ffe3178166bc)。