## 単純なナビゲーション(無線通信無し)
単純なナビゲーション(目的地が一つ)の場合については大体やることは
[こちらのサイト](https://uhobeike.github.io/raspicat_documentation/document/lets_move/navigation/Raspberry%20Pi%20Cat/raspi3_pc_navigation/)
同じです。

Raspberry Pi 3B+のみ場合においては、RAMの関係上ナビゲーションや自己位置推定に必要な**マップの解像度を荒くする**なのど
手順の必要がありました。

Raspberry Pi 4Bのみの場合についてはserverのイメージを使用している関係上Raspberry Pi 4B側で**RVizが立ち上がらないように
する**必要があります。

しかし、この方法は考慮しておかないといけない点があります。それは、初期の自己位置が決まっていることです。
RVizで今までいい感じになるように微調整を行ってきたと思いますが、GUIが使用できないのでなんとなくで初期の位置合わせを行うしかありません。

### 実行コマンド

`mcl_map_file`を**自分のマップのPath**にする必要があります。

* USB LiDARの場合

```
# Raspberry Pi 4B
roslaunch raspicat_navigation raspicat_bringup_navigation.launch waypoint_navigation:=false urg_usb:=true urg_ether:=false mcl_init_pose_x:=0 mcl_init_pose_y:=0 mcl_init_pose_a:=0 mcl_map_file:="" 
```

* Ethernet LiDARの場合

`Ethernet LiDAR`の場合は**LiDARのIPを設定する**必要があります。

```
# Raspberry Pi 4B
roslaunch raspicat_navigation raspicat_bringup_navigation.launch waypoint_navigation:=false urg_usb:=true urg_ether:=false mcl_init_pose_x:=0 mcl_init_pose_y:=0 mcl_init_pose_a:=0 mcl_map_file:="" urg_ip_address:=""
```

## 単純なナビゲーション(無線通信有り)

無線通信が有りの場合だとノートPC側でRVizなどの可視化ツールを使用することが出来ます。

つまり、Raspberry Pi 4B側はコアなプログラムを立ち上げておいて、ノートPC側で可視化のためのプログラムを
立ち上げることで良い感じにストレスフリーになります。（適当な説明）

ここで注意ですが、あまりにも重いデータを送るのは厳しいのでそういったデータのやり取りを行う場合は
圧縮やフィルタをデータに対してかけるなり対策が必要です。ちなみにVLP-16の生の点群データは1sec以内で受け取れていました。

### 実行コマンド

* USB LiDARの場合

```
# Raspberry Pi 4B
roslaunch raspicat_navigation raspicat_bringup_navigation.launch waypoint_navigation:=false urg_usb:=true urg_ether:=false mcl_init_pose_x:=0 mcl_init_pose_y:=0 mcl_init_pose_a:=0 mcl_map_file:="" 
```

今回は、RVizが使用できるので、初期の自己位置をずれていたらRVizで修正しましょう。

```
# ノートPC
rosrun rviz rviz -d $(rospack find raspicat_navigation)/config/rviz/raspicat_navigation_3d.rviz
```

* Ethernet LiDARの場合

```
# Raspberry Pi 4B
roslaunch raspicat_navigation raspicat_bringup_navigation.launch waypoint_navigation:=false urg_usb:=true urg_ether:=false mcl_init_pose_x:=0 mcl_init_pose_y:=0 mcl_init_pose_a:=0 mcl_map_file:="" urg_ip_address:=""
```

```
# ノートPC
rosrun rviz rviz -d $(rospack find raspicat_navigation)/config/rviz/raspicat_navigation_3d.rviz
```