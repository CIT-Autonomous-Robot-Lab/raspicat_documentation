# raspicat_documentation

## preview（use Docker）

```
./mkdocs_serve.sh
```

# raspicat_full Docker Environment

raspicatのナビゲーション（Nav2 + EMCL2）をDocker環境で実行するための手順です。

## 1. イメージの取得

以下のコマンドでDockerイメージをプルします。

```bash
docker pull takabnbn/raspicat_full:v1
```

## 2. 起動スクリプトの作成

```bash
# ディレクトリを作成して移動
mkdir -p shiratama && cd shiratama

# run_docker.sh を作成
cat <<EOF > run_docker.sh
#!/bin/bash
# GUI表示の許可（ホスト側で実行）
xhost +local:docker > /dev/null

# コンテナの起動
docker run -it --rm \\
  --net=host \\
  --env="DISPLAY" \\
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \\
  takabnbn/raspicat_full:v1
EOF

# 実行権限を付与
chmod +x run_docker.sh

echo "Setup complete! 'shiratama' folder created and run_docker.sh is ready."
```

Dockerコンテナの起動
```bash
./run_docker.sh
```
Raspberry Piとノートパソコンの両方で以下を入力
```bash
export ROS_DOMAIN_ID=1
```

ロボット（セットアップ済み）をssh接続し、以下で起動確認
```bash
emcl2_raspicat_nav2.launch.py map:=/opt/project/map.yaml
```
