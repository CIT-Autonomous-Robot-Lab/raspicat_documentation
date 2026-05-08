---
title: 2026しらたま環境Dockerセットアップマニュアル
summary: 2026でしらたまチームが使用したnav2（ウェイポイントナビゲーション）とemcl2のDocker環境
authors:
    - Takaya Mizumaki
    - Keitaro Nakamura
date: 2026-5-8
---

# ウェイポイントナビゲーション
ウェイポイントナビゲーション（Nav2 + EMCL2）を2026しらたまDocker環境で実行する方法を説明します。

## 1. セットアップ（初回のみ）

* 作業ディレクトリの作成
```bash
mkdir -p shiratama && cd shiratama
```

* Dockerイメージの取得
```bash
docker pull takabnbn/raspicat_full:v2
```

* 起動スクリプトの作成
```bash
cat <<EOF > run_docker.sh
```

* GUI表示の許可
```bash
xhost +local:docker > /dev/null
```

* コンテナの起動
```bash
docker run -it --rm \\
  --net=host \\
  --env="DISPLAY" \\
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \\
  takabnbn/raspicat_full:v1
EOF
```

* 実行権限の付与
```bash
chmod +x run_docker.sh
```

## 2. コンテナの起動とビルド
* コンテナの起動（PC）
```bash
./run_docker.sh
```
* ワークスペースの構築（コンテナ内）  
コンテナに入った後、環境の初期化とビルドします。
```bash
cd /opt/project

# キャッシュのクリアと再ビルド
rm -rf build/ install/ log/
colcon build --symlink-install

# 環境の読み込みと通信設定
source install/setup.bash
export ROS_DOMAIN_ID=1
```

!!!通信設定の確認
    重要： ロボット（Raspberry Pi）とノートパソコン（Dockerコンテナ）の両方で、
    必ず以下の環境変数が設定されていることを確認してください。
    ```bash
    export ROS_DOMAIN_ID=1
    ```

## 3. ナビゲーション
* PC側の実行
```bash
ros2 launch raspicat_navigation emcl2_raspicat_nav2.launch.py map:=/opt/project/map.yaml
```
* ラズパイ側の実行
```bash
ros2 launch raspicat raspicat.launch.py
ros2 service call /motor_power std_srvs/SetBool '{data: true}' 
```
