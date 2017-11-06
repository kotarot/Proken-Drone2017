# Proken-Drone2017

## AR.Drone

### インストール

Ubuntu 12.04 -- http://ftp.jaist.ac.jp/pub/Linux/ubuntu-releases/12.04/

SDKダウンロード:
```
cd ~
wget http://developer.parrot.com/docs/SDK2/ARDrone_SDK_2_0_1.zip
unzip ARDrone_SDK_2_0_1.zip
rm -rf __MACOSX  # 要らないから削除
```

サンプルのコンパイル:
```
sudo apt-get update
cd Examples/Linux
make
```

`make` の途中で必要なライブラリ等をインストールするように聞かれるからインストールする．

これで，コンパイル完了．


#### 参考文献

* ドローンの制御について(AR.Drone編) | 安井政人のめざせ！ROSマスター！ | 情報畑でつかまえて https://www.ntt-tx.co.jp/column/yasui_blog/20151104/


### python-ardrone

* https://github.com/venthur/python-ardrone

```
sudo apt-get install pygame
```

動かない......

ちゃんと接続したあとにもう一度試したら，動いた．


### node.js のライブラリ

以下のものがあるけどうまくインストールできない．

* https://github.com/felixge/node-ar-drone


### ARDroneForP5

まず，Processing をインストール．

```
sudo apt-get install openjdk-7-jdk
wget http://download.processing.org/processing-3.3.6-linux64.tgz
tar xzf processing-3.3.6-linux64.tgz
cd processing-3.3.6-linux64
./processing
```

で起動できる．

本体と依存ライブラリのダウンロード:

```
git clone https://github.com/shigeodayo/ARDroneForP5.git
wget http://ftp.tsukuba.wide.ad.jp/software/apache//commons/net/binaries/commons-net-3.6-bin.tar.gz
tar xzf commons-net-3.6-bin.tar.gz
wget http://www.dcm4che.org/maven2/xuggle/xuggle-xuggler/5.4/xuggle-xuggler-5.4.jar
wget https://www.slf4j.org/dist/slf4j-1.7.25.tar.gz --no-check-certificate
tar xzf slf4j-1.7.25.tar.gz
```

したら，`processing` を起動して，
「スケッチ --> ファイルを追加」
で `ARDroneForP5.jar`, `xuggle-xuggler-5.4.jar`, `slf4j-api-1.7.25.jar`, `slf4j-jdk14-1.7.25.jar`, `commons-net-3.6.jar` を追加．

Processing で ARDroneForP5_Sample を実行するとサンプルを動かせる．

#### 参考文献

* ARDroneForP5: ProcessingでAR.Droneをコントロールしよう！ - 工学ナビ http://kougaku-navi.net/ARDroneForP5/


### 参考文献

* 国内・海外AR.Droneプロジェクトまとめ - Puku's Laboratory http://pukulab.blog.fc2.com/blog-entry-20.html


## Bebop 2

TODO.
