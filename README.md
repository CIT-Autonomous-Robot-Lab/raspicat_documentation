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
chmod +x run_docker.sh
cd /opt/project
colcon build --symlink-install
source install/setup.bash
ros2 launch raspicat_navigation
```
Raspberry Piとノートパソコンの両方で以下を入力
```bash
export ROS_DOMAIN_ID=1
```

ロボット（セットアップ済み）をssh接続し、以下で起動確認
```bash
emcl2_raspicat_nav2.launch.py map:=/opt/project/map.yaml
```
