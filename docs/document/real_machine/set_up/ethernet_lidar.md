## 概要
Raspberry Pi CatでEthernet接続のLiDARを使えるようにする方法について説明します。 
[Set Up/有線LAN（Ethernet）](../set_up/wired.md)および[Set Up/無線LAN（Wi-Fi）](../set_up/wireless.md)で、各設定が済んでいる前提で説明をします。

## 必要な物
| Software         | Version                                      |
| ---------------- | -------------------------------------------- | 
| ノートPC         | Ubuntu 22.04（ROS 2 Humble) |
| Raspberry Pi Cat（Raspberry Pi 4B+） | Ubuntu 22.04（ROS 2 Humble) |

| Hardware            |                  | 
| ------------------- | ---------------- | 
| ノートPC            | Raspberry Pi Cat（Raspberry Pi 4B+） | 
| LANケーブル（有線通信の場合） | 2D LiDAR（[北陽](https://www.hokuyo-aut.co.jp/search/?cate01=1)） | 
| USB LAN アダプタ（必要な場合）||

## LiDARと物理的に接続

LiDARのLAN ケーブルをRaspberry Piにつなげ、LiDARの電源を入れる。

## LiDARとソフト的に接続
Raspberry Piで以下を実行する。

```sh
cd ~/raspicat2/src/raspicat_setup_scripts/ether_lidar/scripts
sudo ./setup.sh urg 192.168.0.100 192.168.0.1
sudo nmcli connection up urg
```

!!! info
    ``` sh
    sudo ./setup.sh urg <LIDAR_IP> <HOST_IP>
    ```
    `<LIDAR_IP>` は使用するLiDARによって設定するIPアドレスが異なる。

!!! info
    複数のurgクライアントが立ち上がっている場合は以下を実行して一度削除する。
    ```sh
    sudo nmcli connection delete urg
    ```

## 動作確認
`/scan` トピックにLiDARの取得データがパブリッシュされていればよい。

```sh
ros2 topic echo /scan
```
