# Waypointで思い通りに！？

## 概要
Waypoint navigationの前は[単純なナビゲーション](https://uhobeike.github.io/raspicat_documentation/document/lets_move/navigation/Raspberry%20Pi%20Cat%20V2/raspi4_only_navigation/)
をやったと思います。

単純なナビゲーションでは、`RViz`または`rostopic pub`を使用することによってmove_baseにある目的地を目指すようにデータを送っていました。

単純な環境内、あるいは人間が毎回操作するのであれば問題ないと思いますが、それが面倒だったりそもそも許されない状況下だったりすることがあります。

そういった場合、Waypoint navigationという、複数の中継地点を用意し、通過することで最終的な目的地を目指すようなシステムを利用する必要があります。

### 手順

今回は手順が少し複雑なため、実行コマンド等はこのあとに説明します。

Waypoint navigationを行う手順は大体こんな感じです。

1. マップを用意する(map.pgm、map.yaml)
2. 走行してい欲しいような経路を考えながらマップ上にwaypointを配置していく
3. 配置されたwaypointをcsvやyamlといったデータ形式に変換する（現在はcsvのみ、今後は可読性のためにyamlも追加予定）
4. ノートPC上で取得したcsvデータをRaspberry Piの方に持っていく
5. 変換されたデータ形式を用いて、RVizでのWaypointデータの表示、move_baseに順次目的地を送る

という感じの手順です。なんとなく大体わかったと思うので、Waypoint navigationを実際にやってみましょう！


### 実行コマンド

1.マップを用意する(map.pgm、map.yaml)

完了しているものとします。

2.走行してい欲しいような経路を考えながらマップ上にwaypointを配置していく

`map_file`は絶対パスである必要があります。

csv_fileは`csv_file:=$(rospack find raspicat_navigation)/config/csv/waypoint.csv`とすると良いと思います。

ちなみに`$(rospack find rosのパッケージ名)`は結構便利です。（タブ補完は効かないけど）

```
roslaunch raspicat_navigation waypoint_set.launch csv_file:="$(find raspicat_navigation)/config/csv/" map_file:=""
```

[![Image from Gyazo](https://i.gyazo.com/e444bb08c33a7823be7f12108d77dc36.png)](https://gyazo.com/e444bb08c33a7823be7f12108d77dc36)

[![Image from Gyazo](https://i.gyazo.com/8da33d5f9af7d9e3583dab1a062edeb7.png)](https://gyazo.com/8da33d5f9af7d9e3583dab1a062edeb7)

3.配置されたwaypointをcsvやyamlといったデータ形式に変換する（現在はcsvのみ、今後は可読性のためにyamlも追加予定）

設定したWaypointをなんらかのデータ形式に変換します。
今回はcsvデータ形式で書き出します。今後はyamlデータ形式での書き出しに対応する予定です。

`fキー`を押すとWaypointがcsv形式で書き出されます。(イケてないですね。。)
書き出された場所は、`csv_file`という引数として自分で設定した場所です。(現在は`raspicat_navigation/config/csv/`以下に`waypoint.csv`ファイルが作成されるようになってます)

見てみると、4つのデータがあると思います。

これはクオータニオンで表された姿勢(x, y, z, w)です。
ちなみに、`z`と`w`については足して１(回転の大きさ)になる必要があります。

[![Image from Gyazo](https://i.gyazo.com/ebf786903cf19e6b741f12d268316f0f.png)](https://gyazo.com/ebf786903cf19e6b741f12d268316f0f)

4.変換されたデータ形式(今回はcsv)を用いて、RVizでのWaypointデータの表示

RVizでの表示がイケてないんですけど(ウェイポイントの番号と半径が表示できていない)
一応、Waypointの姿勢を確認できるツールがあるよってことで。。。

バグがあるので現在対応中。

5.ノートPC上で取得したcsvデータをRaspberry Piの方に持っていく

`scp`コマンドを使用します。

```
sudo scp $(rospack find raspicat_navigation)/config/csv/waypoint.csv ubuntu@X.X.X.X:$(rospack find raspicat_navigation)/config/csv/
```

6.変換されたデータ形式(今回はcsv)を用いて、Waypint Navigation(move_baseに順次目的地を送る)

おまたせしました！

Waypoint Navigationがようやくできます。

ここで注意ですが、Waypointが障害物上(グローバルコスト)に無い必要があります。
もし、Waypointが障害物上に配置されている場合グローバルプランナーが上手く機能しない場合があります。
（パラメータでなんとかなるかも？）

* USB LiDARの場合

```
# Raspberry Pi 4B
roslaunch raspicat_navigation raspicat_bringup_navigation.launch waypoint_navigation:=true speak:=false usens_conv:=false urg_usb:=true urg_ether:=false mcl_init_pose_x:=0 mcl_init_pose_y:=0 mcl_init_pose_a:=0 csv_file:="$(find raspicat_navigation)/config/csv/waypoint.csv" mcl_map_file:="" move_base_map_file:="" 
```

```
# ノートPC
rosrun rviz rviz -d $(rospack find raspicat_navigation)/config/rviz/raspicat_navigation.rviz
rostopic pub  -1 /waypoint_start std_msgs/String go
```

* Ethernet LiDARの場合

```
# Raspberry Pi 4B
roslaunch raspicat_navigation raspicat_bringup_？navigation.launch waypoint_navigation:=true speak:=false usens_conv:=false urg_usb:=false urg_ether:=true mcl_init_pose_x:=0 mcl_init_pose_y:=0 mcl_init_pose_a:=0 csv_file:="$(find raspicat_navigation)/config/csv/waypoint.csv" mcl_map_file:="" move_base_map_file:="" urg_ip_address:=""
```

```
# ノートPC
rosrun rviz rviz -d $(rospack find raspicat_navigation)/config/rviz/raspicat_navigation.rviz
rostopic pub  -1 /waypoint_start std_msgs/String go
```

これで、あなたは屋内屋外どこでも思い通りに移動ロボットを走行させる手段を身につけることが出来ました？

屋内ではそうかもしれません、屋外では予想もしないことが起きたり、出くわすことがあります。

ということで、屋外で動かしまくって色んな予想もしないことに遭遇してみましょう。（研究のネタになります）

#### Waypoint Navigationの使用例

<iframe width="560" height="315" src="https://www.youtube.com/embed/Dgd2tOCEYno" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>