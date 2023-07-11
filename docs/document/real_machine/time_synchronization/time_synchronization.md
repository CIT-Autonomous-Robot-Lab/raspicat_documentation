## 概要
**ノート PC**と**Raspberry Pi**間での、**時刻同期**の方法について説明します。  
[Set Up/有線LAN（Ethernet）](../set_up/wired.md)および[Set Up/無線LAN（Wi-Fi）](../set_up/wireless.md)で、各設定が済んでいる前提で説明をします。

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |
| Raspberry Pi Cat（Raspberry Pi 4B+） | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |                  | 
| ------------------- | ---------------- | 
| ノートPC            | Raspberry Pi Cat（Raspberry Pi 4B+） | 
| LANケーブル（有線通信の場合） | | 

## 時刻同期

* 時刻同期の必要性  
主にノートPC（現在時刻が合っている）のみでの作業では、問題ない話ですが、  
ノートPC（現在時刻が合っている）からRaspberry Pi（現在時刻が合っていない）に  
有線、無線通信し、作業をしている時に問題があります。

* 問題が起こる例
    * apt パッケージのインストール時（Raspberry Piで実行）
    * 外部からのファイルをダウンロード時（Raspberry Piで実行）
    * パッケージのビルド時（Raspberry Piで実行）
    * tfを使用したプログラム実行時（どちらでも）
        * マッピングやナビゲーションなど

* 時刻同期の方法（[Set Up/有線LAN（Ethernet）](../set_up/wired.md)で設定が、済んでいる前提）  
<span style="font-size: 150%; color: red;">↓**ノートPC上**で下記のコマンドを実行してください↓</span>
```sh
sudo systemctl restart chrony.service
```