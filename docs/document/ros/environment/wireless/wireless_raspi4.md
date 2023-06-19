# 無線通信でストレスから開放されよう！

## 概要
有線でノートPCからRaspberry Pi Catにsshをして、マッピングやナビゲーションをやるの
正直面倒くさいしハードウェア的に不安定でストレスですよね。

無線だと色々と気が楽になるので、やってみましょう！

## 実行コマンド
```
# Raspberry Pi 4B
git clone https://github.com/uhobeike/raspicat_hotspot.git
cd raspicat_hotspot
./install.sh
```

## 接続方法
`install.sh`を上手く実行できたら、10秒後ぐらいに
[raspicat](https://github.com/uhobeike/raspicat_hotspot/blob/3f92ba2d40aca08b44924008cf65ea9e8945a5b1/raspicat_hotspot.sh#L7)という
名前のホットスポットが立ち上がります。

ノートPCでネットワーク選択から`raspicat`を選択しましょう。
（ちなみにRaspberry Pi Catは複数台あるので同じホットスポット名にすると競合が起こる可能性があるため、
**別名を設定する必要**があることを考慮しておく必要があります。）

[ここに画像が欲しい]

選択できたら、`ip a`コマンドでノートPCのIPアドレスを調べてみましょう。

`192.168.12.XXX`になっていると思われます。
Raspberry Pi側はホットスポットを立ち上げているインターネット共有側なので
`192.168.12.1`のIPアドレスになっています。

各IPアドレスは有線接続時と異なるため、無線でROSの通信を行うためには、
今まで`~/.bashrc`に書いていた**ROSのIP設定を変更する必要**があります。

## 注意点
* Raspberry Pi Catは複数台あるので同じホットスポット名にすると競合が起こる可能性があるため、
**別名を設定する必要**がある。

* **Raspberry Pi側でネットワークを使用する**には`有線接続でのssh`かつ`PC側でインターネット利用が可能なアクセスポイントを選択`している必要があります。（切り替えるの面倒くさい問題がありますが、外付けの無線LANを使用すれば切り替えずに済むかも知れません）