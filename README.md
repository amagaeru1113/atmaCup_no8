# atmaCup_no8


![atmaCup#8](https://www.artic.edu/iiif/2/6ec24413-4458-4845-4fe3-8171639f26f9/full/1686,/0/default.jpg "Young Peasant Having Her Coffee")

参考：[kaggle日記][kaggle_diary]

## [初心者向atmaCup][atmaCup]

### 概要
ゲームの情報を使って、ゲームの売上を予測します。使えるデータに関しては data sources から閲覧できます。

### タイムライン
- 2020/12/04 18:00 ~ 2020/12/13 18:00 (Asia/Tokyo)

開催期間中に @nyk510 による初心者向け講座を開催予定です。
- 2020/12/05: 13:00 ~ 14:00 | データを眺めて submission する
- 2020/12/06: 17:00 ~ 18:00 | より深くデータを見て予測性能を改善する

### Prize
private leaderboard 上位 (通常LB + 敢闘賞LB) のチームに atma 謹製のメダルをお送りします。また開催期間中ディスカッションで最も「いいね」をもらえたユーザーにも nyk510 賞をお送りします。

(上記入賞については submit に使用したコードの提出、並びに submit の再現が取れると運営が判断した後お送りいたします。内容の再現が取れない等、場合によっては表彰を取りやめる場合がございますこと、ご承知おきくださいませ。)

## Command

コンテナ起動
`docker-compose start`

コンテナに入る
`deit atmacap_no8_compe-box_1 /bin/bash`

コンテナ上で実行
`jupyter lab --ip=0.0.0.0 --allow-root --no-browser --NotebookApp.token=''`

<!-- https://qiita.com/tay2501/items/1f82f16447bdff86247d -->
<!-- http://sweng.web.fc2.com/ja/program/python/jupyter-notebook.html -->

## Info

- metric:[RMSLEの話][RMSLE_memo]
- CVLog: [spread sheet][https://docs.google.com/spreadsheets/d/1wwAUyKqVpQAk9revSrsJkd7qMdwX6uwzxfx7F_tr8SY/edit?usp=sharing]


## Dataset

|name|detail|ref|
|-|-|-|
||||

## Discussion

|title|summary|memo|
|-|-|-|
|dis1|sum|memo|


## Log

### 2020/12/05
- join
- 環境構築（poetry + docker + jupyterlab）
- 初心者向け分析講座を視聴。notebookはnotebook_downloadsに入れる。

### 2020/12/07
- スプレッドシートでtrainを眺める
    - Name: シリーズ物の特徴とかありそう
    - Platform: ハード。数字はなんだ？ Atari2600ぽい
    - Year_of_Release: 発売年度がnanがある
    - Genre
    - Publisher
    - NA_Sales
    - EU_Sales
    - JP_Sales
    - Other_Sales
    - Global_Sales
    - Critic_Score: 評論家のスコアだけどAtaiのスコア付けがない？他のもないからパターンがわからない
    - Critic_Count
    - User_Score
    - User_Count
    - Developer: デベロッパーがないところはCritic_socreからRatingまでがない
    - Rating

### 2020/12/08
#### Colabで分析初心者講座1のnotebookをみながらのメモ

<details>
<summary>Baseline</summary>

- pandas_profilingで各カラムの特徴を見る
    - Name
        - 欠損なし
        - ユニークな値が約75%
        - シリーズ物の判定は聞きそう。ナンバリングされているか、固有の名称を持っているか（LEGO、Zeldaとか）
    - Platform
        - 欠損なし
        - よく聞くハードかそうでないかは聞くかな？普及率が違いそうだし。(任天堂、SONY)
    - Year_of_Release
        - 欠損84こあり（1%）
        - 1990年を境にして次第に発売が増えている気がする
    - Genre
        - 欠損なし
        - 値12個なので、そのまま使って良さそう
        - 仮にやるとしたらアクション要素があるかとか？ちょっと微妙
    - Publisher
        - 欠損なし
        - 値が295もあるので有名どころとOtherで分ける特徴量があっても良さそう
    - NA_sales（北米市場の販売量）
        - 欠損はないけど、Zerosは30%近くある
        - 多くのソフトは0付近
    - EU_sales（欧州市場の販売量）
        - 欠損はないが、35%くらいはZeros
        - こちらも0付近に多くのソフトがある
    - JP_sales（日本市場での販売量）
        - 欠損なしの40%近くがZeros
        - こちらも0付近に多くのソフトがある
    - Other_sales(上記以外の地域での販売量)
        - 欠損なし、40％近くがZeros
        - こちらも0付近に多くのソフトがある
    - Global_sales(世界全体での販売量)
        - 欠損なし、Zerosなし。つまり、北米市場では売れていなくてもどこかでは売れている？
    - Critic_Score（評論家のレビュースコア）
        - 欠損が50%こえ
    - Critic_Count（評論家のレビュー数）
        - 欠損が50%こえ
    - User_Score（ユーザーレビュースコア）
        - 欠損40%こえ
        - 小数点1位まで使うっぽいなあ
        - tbdってなんや（[参考][tbd]）この扱いはわから
            - TBC = To Be Confirmed  （確認中）
            - TBD = To Be Determined  （現在未決定だが、将来決定する）
            - TBA = To Be Announced  （後日発表）
    - User_count(ユーザーレビュー数)
        - 欠損55%
        - 0付近に多いなあ。どのソフトも大量のレビューがあるわけではない。
    - Developer（開発元）
        - 大手の開発元とそうでないで分けられないか（開発ソフト数が100本以上なら大手とか）
    - Rating
        - ゲームのレーティング
        - 年齢制限とか暴力表現とかの区分
         
- ベン図を見て
    - Publisherが全然重なっていない。test.csv見てみるとunknownが割とある.
    - Developerも半分くらい重なっている程度。
    - 上二つの特徴量はどれくらい寄与するか
- 特徴量の話
    - 暗黙的な仮定を意識する
        - 連続値の大小には意味がある
        - 大小関係に意味がないものはカテゴリ変数にしてしまう
        - 時間を極座標で表現するのには驚いた。そういうのもあるのか。
    - Boolean
        - テキストカラムに特定の文字列が含まれているかの判定とか
- LightGBMの学習
    - CVの切り方にも戦略が必要。現実の分布に対応して予測しなくてはいけないから。
</details>


#### Youtubeで分析初心者講座2をみながらのメモ

<details>
<summary>モデルの改善</summary>

- tbdを全てNanにしてたが、情報があるかもしれないので別のフラグを持たせる→情報量を落とさないようにしてる
- CountEncoding：カテゴリ変数のクラスが何回出現したか
    - 何回出てきたかという基準で並び替えられる
- One-HotEncoding: ダミー変数化する。
    - ユニークな値が多いとカラムが膨大になるのと、情報があまり増えない
    - 他のクラスとの距離が同じになる
- testにない情報を使いたい
    - trainとtestに共通するカラムにtrainにしかないカラムの情報をつなげる

</details>



- [RMSLE を最適化する小技][RMSLEkowaza]



### 2020/12/09

- [Cross Validationについて][discuss_takaito]
    - Publicherの取り扱いがここにも効いてる？

特徴量生成の勘所がまだわからないので、作ってCV見てをやる
- PlatformとGenreをつなげてカテゴリ変数を作る
    - ハードによって人気ジャンルが微妙に変わったりしないか
    - RMSLEが0.1くらい増えたのでスコアとしては悪くなった？

- Year_of_releaseをみると1990, 2000, 2010を境に増減があるような気がする
    - 1990, 2000, 2010でカテゴリA,B,C,Dに分ける。nan等はE。

- CricitやUserのScore、Countを使ってみる
    - Criticは100点満点でUserは10点満点ポイ
    - scoreとcountを乗算した特徴量を作る

### 2020/12/10
- spread sheetにCVとか記録し始める（判断が遅い）
- [Nameからシリーズ名の抽出][series_from_name]levenstein

#### シリーズ名の取得試行錯誤
- [【Python】『レーベンシュタイン距離』を計算してみた][levenshtein]
- [2つの文字列間で共通の部分文字列を見つける][common_prefix]


###　2020/12/11
- nameからシリーズを取り出す→うまいことできない
    - tf-idfして似ているタイトル抽出できるか
- Publisher_Genre_Count：publisherごとのgenre数→これで0.8突入
- Publisher_Platform_Count：publisherごとのplatform数→あんまり変わらんかった
- Violence：ratingの暴力表現を含むかどうかでbooleanを作る
    - M、AOであればviolenceだとする
    - ViolenceカラムをCountEncodingしたりSalesにいれるとスコアが良くなった。
    - これでちゃんと理由まで把握してやれるようにならないといけないが、現状はスコアを追うだけで精一杯やな。
- 編集距離の近い物で最澄一致文字列を取得するやつでシリーズタイトルをとる？
- whole_dfでPublicher=Unknownは不明なのでNaNにする。Unknownて言う会社があることになるから。

### 2020/12/12
- [PCAとKmeansのdisscuss][disscuss_takaby]を参考にPCA、Kmeansをカラム追加してみる
    - PCAカラムは扱いがわかってなくて改善せず
    - Kmeansは多少改善したか？
- 実験管理のミスで何をしてスコアが0.9に戻ったかわからなくなる

### 2020/12/13
- 今日の18時が締め切り
- Publisher_Genre_Count系列で色々足し引きしてみる


### 終了
スコア0.9036 shakedown 4
- LB：44位　
- LB敢闘賞:40位

[リーダーボード][leaderboard]
<!-- refs -->
[kaggle_diary]:https://github.com/fkubota/kaggle-Cornell-Birdcall-Identification
[atmaCup]:https://www.guruguru.science/competitions/13/
[RMSLE_memo]:https://qiita.com/shnchr/items/a88b1eb2bba8002ecd5d
[tbd]:https://www.quicktranslate.com/blog/2013/11/%E8%8B%B1%E8%AA%9E%E3%81%AE%E8%B3%87%E6%96%99%E3%81%AB%E5%87%BA%E3%81%A6%E3%81%8F%E3%82%8B%EF%BC%88tbc%EF%BC%89%E3%82%84-%EF%BC%88tbd%EF%BC%89%E3%81%AF%E4%BD%95%E3%81%AE%E7%95%A5%EF%BC%9F/
[RMSLEkowaza]:https://www.guruguru.science/competitions/13/discussions/cbb736e9-f0f7-4847-811e-fe038e8ed0e8/
[discuss_takaito]:https://www.guruguru.science/competitions/13/discussions/42fc473d-4450-4cfc-b924-0a5d61fd0ca7/
[series_from_name]:https://www.guruguru.science/competitions/13/discussions/c6874ba1-4f51-46d2-85e5-69d3b767d77e/
[common_prefix]:https://www.it-swarm-ja.tech/ja/python/2%E3%81%A4%E3%81%AE%E6%96%87%E5%AD%97%E5%88%97%E9%96%93%E3%81%A7%E5%85%B1%E9%80%9A%E3%81%AE%E9%83%A8%E5%88%86%E6%96%87%E5%AD%97%E5%88%97%E3%82%92%E8%A6%8B%E3%81%A4%E3%81%91%E3%82%8B/1042437700/
[levenshtein]:https://qiita.com/ayuma/items/befa11396a7c3cc10f6c
[disscuss_takaby]:https://www.guruguru.science/competitions/13/discussions/8c7a3e1b-55f8-4c93-9897-b331346afbfd/
[leaderboard]:https://www.guruguru.science/competitions/13/leaderboard 