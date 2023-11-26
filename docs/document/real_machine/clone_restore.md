---
title: クローン
summary: Raspberry Pi のSDカードのバックアップとリストア
authors:
    - Ikuo Shige
date: 2023-10-17
---

# Raspberry Pi のSDカードのクローン

## バックアップイメージの取得とリストア

=== "ddコマンド"
    1. `sudo parted -l` を使用してSDカードのパスを確認
    1. `sudo umount /dev/sdX` を実行してSDカードをアンマウント

        !!! example
            - クローン元: 
                - /dev/sdX
                - /dev/mmcblk0
            - クローン先: 
                - /dev/sdY
                - /dev/mmcblk1

    1. ディスクのイメージを作成
        ```bash
        sudo dd if=/dev/sdX conv=sync,noerror bs=4M status=progress | gzip -c > /path/to/image-file/<image-name>.img.gz
        ```
    1. ディスクのイメージのリストア
        ```bash
        gunzip -c /path/to/image-file/<image-name>.img.gz | sudo dd of=/dev/sdY bs=4M status=progress
        ```
    1. クローンが完了したらSDカードをRaspberry Piデバイスに挿し、起動する

=== "Gparted"
    ### Gpartedとは
    ディスクパーティションとファイルシステムの作成、削除、リサイズ、移動、検査、そして複製に使用される。新しいオペレーティングシステム (OS) 用の領域の作成、ディスク使用状況の再編成、ハードディスク上のデータの複製、そしてあるパーティションの別パーティションへのミラーリング（ディスクイメージング）に有用なフリーソフト。

    ### install
    ```bash
    sudo apt install -y gparted
    ```

    ### 準備
    クローン先のSDカードのパーティションを全て削除しておく

    ### クローン
    Gaprtedを起動
    ```bash
    gparted
    ```

    1. 右上にある下向きの矢印をクリックしてクローン元のディスクを選択
    1. 一番左のパーティションをクリックし、右クリックしてコピーを選択
    1. 右上にある下向きの矢印をクリックしてクローン先のディスクを選択
    1. 未割り当て領域で右クリックし貼り付けを選択
    1. 1-4を末尾のパーティションまで繰り返す
    1. 緑色のチェックボタンをクリックし、全ての操作を適用する
    1. 処理が完了したらGpartedを終了し、SDカードをPCから抜きRaspverry Piデバイスに挿し起動する

=== "スクリプトを実行"

    ```bash
    #!/bin/bash

    # 引数からデバイスのパスを取得
    input_device_path="$1"
    device_path="$2"

    # デバイスのパスが指定されていない場合、エラーメッセージを表示して終了
    if [ -z "$device_path" ]; then
    echo "デバイスのパスを指定してください。"
    exit 1
    fi

    # パーティション情報を配列に抽出
    mapfile -t partition_info < <(sudo parted "$device_path" -s unit s print | awk '/^ *[0-9]+/ {gsub(/,/, "", $7); print $1, $2, $3, $7, $6, $5}')

    # 配列の要素を表示
    for ((i = 0; i < ${#partition_info[@]}; i++)); do
    info="${partition_info[i]}"
    IFS=" " read -r number start end flags name filesystem <<< "$info"

    echo "パーティション番号: $number"
    echo "開始セクタ: $start"
    echo "終了セクタ: $end"
    echo "ファイルシステム: $filesystem"
    echo "名前: $name"
    echo "フラグ: $flags"
    echo "-------------------------"
    if [[ "$filesystem" == "ext4" ]]; then
        sudo parted "$device_path" mktable gpt
        wait
        sudo parted "$device_path" mkpart $name $filesystem $start $end -a none
        wait
        sudo e2image -ra -p -f "$input_device_path$number" "$device_path$number"
        wait
        e2fsck -f -y -v "$device_path$number"
        wait
        sudo parted "$device_path" set $number $flags on
    else
        sudo parted "$device_path" mkpart $name $filesystem $start $end -a none
        wait
        sudo dd if="$input_device_path$number" of="$device_path$number" bs=1M status=progress
        wait
        sudo parted "$device_path" set $number $flags on
        wait
    fi
    done

    echo "finish."
    ```

    ### スクリプトの準備

    ```bash
    vim clone.sh
    ```
    上記のスクリプト内容を貼り付けて保存

    権限を与える
    ```bash
    chmod +x clone.sh
    ```

    ### 実行
    ```bash
    ./clone.sh /dev/<クローン元> /dev/<クローン先>
    ```
