# 楽しいナビゲーション!

## 概要
Raspberry Pi Catで**ナビゲーション**を行う方法を説明します。

## 必要な物
`ナビゲーション時にJoystick controllerは使用しないため`必要なものリストから除外しています。

| Hardware            |                  | 
| ------------------- | ---------------- | 
| Raspberry Pi Cat    | ノートPC         | 
| LANケーブル         | 2D LiDAR（遠くまで見れるかつデータにノイズが少ないものが良い）         | 

## 実行コマンド

```
# Raspberry Pi 3B+
roslaunch raspicat_navigation raspicat_bringup.launch urg_serial_port:=/dev/ttyACM0 urg_ether:=false urg_usb:=true
```

↓hoge以降はマッピングしたマップの詳細が記述されたyamlファイルまでのパスを指定します。

```
# ノートPC
roslaunch raspicat_navigation raspicat_navigation.launch waypoint_navigation:=false mcl_map_file:="$HOME/hoge.yaml"
```

## 実行後にやること

navigation.launchの実行後にRVizが立ち上がったと思います。

RViz上のRaspberry Pi Cat位置と実際のRaspberry Pi Cat位置を揃える必要があるので
2D Pose Estimateで揃えましょう。（amclノードに/initialposeトピックを渡すことが出来ます)

上手く揃えることが出来るとRaspberry Pi Catから得られるscanとmapがRViz上で上手くマッチングしていることがわかります。
少しずれても問題はありませんが、ずれすぎると自己位置推定/ナビゲーションが破綻する場合があります。

続いて、上手く初期位置もセットできたので、いよいよナビゲーションをスタートさせましょう。
2D Nav Goalボタンで目標地の姿勢を設定します。（move_baseノードに/move_base_simple/goalトピックを渡すことが出来ます)

[![Image from Gyazo](https://i.gyazo.com/6a6cffbb61bc12ac18e2ef67876e7c33.png)](https://gyazo.com/6a6cffbb61bc12ac18e2ef67876e7c33)

ここで注意ですが動かす前は**非常停止スイッチがOFF**になっていることを確認しましょう。

さて、目的地まで自律的に移動し、上手く到達することが出来たでしょうか？

出来なかった場合は、改善策を考えると良いと思います。

パラメータがダメだった？何か新しいアルゴリズムが必要？新しいセンサーが必要？学習に任せれば出来そう？

色々考えると楽しいです。

## 参考資料
ナビゲーションは主にROSのナビゲーションスタックを使用しています。

ナビゲーションスタックには様々なパッケージがあり、それぞれを組み合わせることでナビゲーションを実現しています。

例えば、Global planner、Local planner、Cost mapなど様々な機能があります。

[こちらのサイト](https://robo-marc.github.io/navigation_documents/introduction.html)はその全体の仕組みをわかりやすく解説してくれているサイトです。（パラメータについても書かれています。）

またナビゲーションもパラメータがたくさんあるのでroswikiを見ると良いです。

### ナビゲーションroswikiリスト

#### ・[amcl(自己位置推定)](http://wiki.ros.org/amcl)

#### ・[move_base](http://wiki.ros.org/move_base)

#### ・[global_planner](http://wiki.ros.org/global_planner)

#### ・[local_planner](http://wiki.ros.org/dwa_local_planner)

#### ・[costmap_2d(障害物用)](http://wiki.ros.org/costmap_2d)

#### ・[recovery behaviors(回復行動用)](http://wiki.ros.org/rotate_recovery)

## 応用編!!?

目標値をいくつか設定して、そのとおりにナビゲーションを行いたい場合、
ウェイポイントナビゲーションを行う必要があります。

ウェイポイントナビゲーションを行うには自前のソースコードまたは誰かが実装したソースコードが必要です。

上田研の自律移動チームでは[こちら(uhobeike/raspicat_navigation)](https://github.com/uhobeike/raspicat_navigation)のパッケージを使用してウェイポイントナビゲーションを行っています。

ウェイポイントナビゲーションに関するドキュメントは、これからまとめる予定です。

**自己位置推定やプランナーも色々なパッケージがあるので有名所のものを色々試すと良いです！**

**もちろん、自分でアルゴリズムを実装するのもアリです！**