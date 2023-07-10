## 概要
Raspberry Pi Catに無線経由でssh接続するまでの方法について説明します。  
[Set Up/有線LAN（Ethernet）](../set_up/wired.md)で、各設定が済んでいる前提で説明をします。

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |
| Raspberry Pi Cat（Raspberry Pi 4B+） | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |                  | 
| ------------------- | ---------------- | 
| ノートPC            | Raspberry Pi Cat（Raspberry Pi 4B+） | 
| LANケーブル |  | 

## 無線経由でのssh接続方法

#### Raspberry Pi

* Raspberry Piでホットスポットを立ち上げる  
`<your-name>`の部分は変更しましょう。
```sh
export HOTSPOT_SSID=raspicat-<your-name>
```
```sh
grep -q "export HOTSPOT_SSID_NAME=$HOTSPOT_SSID" ~/.bashrc || echo "export HOTSPOT_SSID_NAME=$HOTSPOT_SSID" >> ~/.bashrc
colcon_cd raspicat_setup_scripts
./hotspot/scripts/install.sh
```

#### ノートPC


* ノートPC側でネットワークを切り替える  
10秒ぐらいするとノートPC側でRaspberry Piで立ち上げた  
ホットスポットのSSIDが見えるようになります。
[![Image from Gyazo](https://i.gyazo.com/f8d062086a3f1eb98c692913035d2573.png)](https://gyazo.com/f8d062086a3f1eb98c692913035d2573)
Raspberry Piで立ち上げたホットスポットのSSIDを選択し、ネットワークを切り替えます。  
ノートPC側は、ネットワークが切り替わるまで少し時間が掛かります。  

* 無線経由でssh接続  
現在、ノートPCがアクセスしているネットワークは、Raspberry Pi側で立ち上げたものです。  
そのため、Raspberry Pi側のIPアドレスは、`192.168.12.1`です。  
このIPアドレスは変わりません。
```sh
ssh ubuntu@192.168.12.1
```

!!! Warning
    Raspberry Piのホットスポットに接続している場合、外部のネットワークへの通信ができなくなります。  
    Googleでの検索等がしたい場合は、ノートPCでEthernet接続をして通信をする方法があります。