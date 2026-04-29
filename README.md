# raspicat_documentation
## preview（use Docker）
```
./mkdocs_serve.sh
```
以下水牧

# raspicat_full Docker Environment
raspicatのナビゲーション（Nav2 + EMCL2）をDocker環境で実行するための手順です。

# 1. セットアップ（初回のみ）
ホストPC側で以下のブロックをコピー＆ペーストして実行してください。shiratama ディレクトリの作成から、Dockerイメージの取得、起動スクリプトの作成まで一括で行います。
```bash
# 作業ディレクトリの作成
mkdir -p shiratama && cd shiratama

# Dockerイメージの取得
docker pull takabnbn/raspicat_full:v1

# 起動スクリプトの作成
cat <<EOF > run_docker.sh
#!/bin/bash
# GUI表示の許可
xhost +local:docker > /dev/null

# コンテナの起動
docker run -it --rm \\
  --net=host \\
  --env="DISPLAY" \\
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \\
  takabnbn/raspicat_full:v1
EOF

# 実行権限の付与
chmod +x run_docker.sh

echo "Setup complete! 'shiratama' folder is ready."
```

# 2. コンテナの起動とビルド
## ステップ1：コンテナの起動（ホストPC）
```bash
./run_docker.sh
```
## ステップ2：ワークスペースの構築（コンテナ内）
コンテナに入ったら、以下のコマンドで環境を初期化・ビルドします。
```bash
cd /opt/project

# キャッシュのクリアと再ビルド
rm -rf build/ install/ log/
colcon build --symlink-install

# 環境の読み込みと通信設定
source install/setup.bash
export ROS_DOMAIN_ID=1
```
# 3. ナビゲーションの実行
通信設定の確認
重要： ロボット（Raspberry Pi）とノートパソコン（Dockerコンテナ）の両方で、必ず以下の環境変数が設定されていることを確認してください。
```bash
export ROS_DOMAIN_ID=1
```
# 実行コマンド
ロボット側にSSH接続(注1)し、以下のコマンドでナビゲーション（EMCL2 + Nav2）を起動します。
ホストで
```bash
ros2 launch raspicat_navigation emcl2_raspicat_nav2.launch.py map:=/opt/project/map.yaml
```
ロボット側(ssh接続した画面)で
```bash
ros2 service call /motor_power std_srvs/SetBool '{data: true}' # <-タイムアウトしたらもう一回実行
ros2 launch raspicat raspicat.launch.py
```

# 注1
ssh接続について(しらたまの場合)
```bash
ssh ubuntu@10.42.0.13
pass:2563
```
で接続できると思う
もしかしたらsshキーとかうんたらかんたら表示されるかもですが、調べてやってみてください♡
