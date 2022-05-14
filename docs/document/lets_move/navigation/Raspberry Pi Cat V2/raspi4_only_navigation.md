## 単純なナビゲーション
単純なナビゲーション(目的地が一つ)の場合については大体やることは
[こちらのサイト](https://uhobeike.github.io/raspicat_documentation/document/lets_move/navigation/Raspberry%20Pi%20Cat/raspi3_pc_navigation/)
同じです。

Raspberry Pi 3B+のみ場合においては、RAMの関係上ナビゲーションや自己位置推定に必要な**マップの解像度を荒くする**なのど
手順の必要がありました。

Raspberry Pi 4Bのみの場合についてはserverのイメージを使用している関係上Raspberry Pi 4B側で**RVizが立ち上がらないように
する**必要があります。

しかし、この方法は考慮しておかないといけない点があります。それは、初期の自己位置が決まっていることです。
RVizで今までいい感じになるように微調整を行ってきたと思いますが、GUIが使用できないのでなんとなくで初期の位置合わせを行うしかありません。

`mcl_map_file`と`move_base_map_file`を**自分のマップのPath**にする必要があります。

* USB LiDARの場合

```
# Raspberry Pi 4B
roslaunch raspicat_navigation raspicat_bringup_navigation.launch waypoint_navigation:=false urg_usb:=true urg_ether:=false model:="$(rospack find raspicat_navigation)/config/urdf/raspicat.urdf.xacro" mcl_map_file:="" move_base_map_file:=""
```

* Ethernet LiDARの場合

`Ethernet LiDAR`の場合は**LiDARのIPを設定する**必要があります。

```
# Raspberry Pi 4B
roslaunch raspicat_navigation raspicat_bringup_navigation.launch waypoint_navigation:=false urg_usb:=true urg_ether:=false model:="$(rospack find raspicat_navigation)/config/urdf/raspicat.urdf.xacro" mcl_map_file:="" move_base_map_file:="" urg_ip_address:=""
```