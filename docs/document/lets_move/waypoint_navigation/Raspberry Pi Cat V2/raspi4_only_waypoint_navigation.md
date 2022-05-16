# Waypointで思い通りに！？

## 概要
Waypoint navigationの前は[単純なナビゲーション](https://uhobeike.github.io/raspicat_documentation/document/lets_move/navigation/Raspberry%20Pi%20Cat%20V2/raspi4_only_navigation/)
をやったと思います。

単純ナビゲーションでは、`RViz`または`rostopic pub`を使用することによってmove_baseにある一つの目的地を目指すようにデータを送っていました。

単純な環境内、あるいは人間が毎回操作するのであれば問題ないと思いますが、それが面倒だったりそもそも許されない状況下だったりすることがあります。

そういった場合、Waypoint navigationという、複数の中継地点を用意することで最終的な目的地を目指すようなシステムを利用する必要があります。

### 手順

今回手順が少し複雑なため、実行コマンド等はこのあとに説明します。

Waypoint navigationを行う場合の手順は大体こんな感じです。

1. マップを用意する(map.pgm、map.yaml)
2. マップを使用して走行してい欲しいような経路を考えながらwaypointを配置していく
3. 配置されたwaypointをcsvやyamlといったデータ形式に変換する
4. 変換されたデータ形式を用いて、RVizでのWaypointデータの表示、move_baseに順次目的地を送る

