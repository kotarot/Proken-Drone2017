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


### 参考文献

* ドローンの制御について(AR.Drone編) | 安井政人のめざせ！ROSマスター！ | 情報畑でつかまえて https://www.ntt-tx.co.jp/column/yasui_blog/20151104/


## Bebop 2
