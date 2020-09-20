# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require "csv"

CSV.foreach('db/csv/region1.csv', headers: true) do |row|
  Region1.create(
    name: row['name']
  )
end

CSV.foreach('db/csv/prefecture.csv', headers: true) do |row|
  Prefecture.create(
    name: row['name'],
    region1_id: row['region1_id']
  )
end

CSV.foreach('db/csv/city.csv', headers: true) do |row|
  City.create(
    name: row['name'],
    code: row['code'],
    yomigana: row['yomigana'],
    prefecture_id: row['prefecture_id']
  )
end

CSV.foreach('db/csv/clinics.csv', headers: true) do |row|
  Clinic.create(
    name: row['name'],
    post_code: row['post_code'],
    address1: row['address1'],
    address2: row['address2'],
    tel: row['tel'],
    jsog_code: row['jsog_code'],
    senkoishido: row['senkoishido'],
    fujinkashuyo: row['fujinkashuyo'],
    shusanki: row['shusanki'],
    ivf: row['ivf'],
    hai_ranshi_toketsu: row['hai_ranshi_toketsu'],
    kenbijusei: row['kenbijusei'],
    social_ranshitoketsu: row['social_ranshitoketsu'],
    teikyoseishi_aih: row['teikyoseishi_aih'],
    pgt: row['pgt'],
    jis_art: row['jis_art'],
    japco: row['japco'],
    yomigana: row['yomigana'],
    current_status: row['current_status'],
    prefecture_id: row['prefecture_id'],
    city_id: row['city_id']
  )
end

Supplement.create([
  { name: "亜鉛", yomigana: "アエン" },
  { name: "アルギニン", yomigana: "アルギニン" },
  { name: "イノシトール", yomigana: "イノシトール" },
  { name: "L-アルギニン", yomigana: "エルアルギニン" },
  { name: "L-カルニチン", yomigana: "エルカルニチン" },
  { name: "コエンザイム", yomigana: "コエンザイム" },
  { name: "鉄分", yomigana: "テツブン" },
  { name: "DHEA", yomigana: "ディーエイチイーエー" },
  { name: "ビタミンC", yomigana: "ビタミンシー" },
  { name: "ビタミンD", yomigana: "ビタミンディー" },
  { name: "ビタミンE", yomigana: "ビタミンイー" },
  { name: "プラセンタ", yomigana: "プラセンタ" },
  { name: "マカ", yomigana: "マカ" },
  { name: "ミトコンドリア", yomigana: "ミトコンドリア" },
  { name: "メラトニン", yomigana: "メラトニン" },
  { name: "ラクトフェリン", yomigana: "ラクトフェリン" },
  { name: "レスベラトロール", yomigana: "レスベラトール" },
  { name: "葉酸", yomigana: "ヨウサン" },
  { name: "その他", yomigana: "ンンン" },
])

MSupplement.create([
  { name: "亜鉛", yomigana: "アエン" },
  { name: "コエンザイム", yomigana: "コエンザイム" },
  { name: "ビタミンD", yomigana: "ビタミンディー" },
  { name: "ビタミンE", yomigana: "ビタミンイー" },
  { name: "マカ", yomigana: "マカ" },
  { name: "その他", yomigana: "ンンン" },
])

FDisease.create([
  { name: "黄体化非破裂卵胞(LUF)", yomigana: "オウタイカヒハレツランポウ" },
  { name: "黄体機能不全", yomigana: "オウタイキノウフゼン" },
  { name: "遺残卵胞", yomigana: "イザンランポウ" },
  { name: "下垂体性排卵障害(中枢性の排卵障害)", yomigana: "カスイタイセイハイランショウガイ" },
  { name: "下垂体線種", yomigana: "カスイタイセンシュ" },
  { name: "希発月経", yomigana: "キハツゲッケイ" },
  { name: "クラミジア性卵管炎", yomigana: "クラミジアセイランカンエン" },
  { name: "頸管粘液分泌不全", yomigana: "ケイカンネンエキブンピフゼン" },
  { name: "甲状腺機能亢進症", yomigana: "コウジョウセンキノウコウシンショウ" },
  { name: "甲状腺機能低下症", yomigana: "コウジョウセンキノウテイカショウ" },
  { name: "抗精子抗体", yomigana: "コウセイシコウタイ" },
  { name: "高プロラクチン血症", yomigana: "コウプロラクチンケッショウ" },
  { name: "子宮筋腫", yomigana: "シキュウキンシュ" },
  { name: "子宮頸管粘液不全", yomigana: "シキュウケイカンネンエキフゼン" },
  { name: "子宮腺筋症", yomigana: "シキュウセンキンショウ" },
  { name: "子宮先天奇形", yomigana: "シキュウセンテンキケイ" },
  { name: "子宮体がん", yomigana: "シキュウタイガン" },
  { name: "子宮内腔癒着症(アッシャーマン症候群)", yomigana: "シキュウナイクウユチャクショウ" },
  { name: "子宮内膜症", yomigana: "シキュウナイマクショウ" },
  { name: "子宮内膜ポリープ", yomigana: "シキュウナイマクポリープ" },
  { name: "子宮発育不全", yomigana: "シキュウハツイクフゼン" },
  { name: "視床下部排卵障害(中枢性の排卵障害)", yomigana: "シショウカブハイランショウガイ" },
  { name: "早発性卵巣機能不全", yomigana: "ソウハツセイランソウキノウフゼン" },
  { name: "多嚢胞性卵巣症候群(PCOS)", yomigana: "タノウホウセイランソウショウコウグン" },
  { name: "チョコレート嚢胞", yomigana: "チョコレートノウホウ" },
  { name: "内分泌ホルモン異常", yomigana: "ナイブンピホルモンイジョウ" },
  { name: "乳がん", yomigana: "ニュウガン" },
  { name: "橋本病", yomigana: "ハシモトビョウ" },
  { name: "バセドウ病", yomigana: "バセドウビョウ" },
  { name: "慢性頸管炎", yomigana: "マンセイケイカンエン" },
  { name: "無月経", yomigana: "ムゲッケイ" },
  { name: "無排卵", yomigana: "ムハイラン" },
  { name: "卵管狭窄", yomigana: "ランカンキョウサク" },
  { name: "卵管狭窄炎", yomigana: "ランカンキョウサクエン" },
  { name: "卵管周囲癒着", yomigana: "ランカンシュウイユチャク" },
  { name: "卵管閉鎖", yomigana: "ランカンヘイサ" },
  { name: "卵管留水腫", yomigana: "ランカンリュウスイシュ" },
  { name: "卵巣過剰刺激症候群", yomigana: "ランソウカジョウシゲキショウコウグン" },
  { name: "卵巣がん", yomigana: "ランソウガン" },
  { name: "卵巣機能低下", yomigana: "ランソウキノウテイカ" },
  { name: "卵巣嚢胞", yomigana: "ランソウノウホウ" },
  { name: "その他", yomigana: "ンンン" },
])

MDisease.create([
  { name: "ED(勃起障害)", yomigana: "イーディ" },
  { name: "奇形精子症", yomigana: "キケイセイシショウ" },
  { name: "逆行性射精", yomigana: "ギャッコウセイシャセイ" },
  { name: "クラインフェルター症候群", yomigana: "クラインフェルターショウコウグン" },
  { name: "精液性状低下", yomigana: "セイエキセイジョウテイカ" },
  { name: "精索静脈瘤", yomigana: "セイサクジョウミャクリュウ" },
  { name: "精子無力症", yomigana: "セイシムリョクショウ" },
  { name: "精路閉鎖", yomigana: "セイロヘイサ" },
  { name: "先天性精管欠損", yomigana: "センテンセイセイカンケッソン" },
  { name: "膣内射精障害", yomigana: "チツナイシャセイショウガイ" },
  { name: "痛風", yomigana: "ツウフウ" },
  { name: "糖尿病", yomigana: "トウニョウビョウ" },
  { name: "膿精液症", yomigana: "ノウセイエキショウ" },
  { name: "閉塞性無精子症", yomigana: "ヘイソクセイムセイシショウ" },
  { name: "乏精子症", yomigana: "ボウセイシショウ" },
  { name: "無精液症", yomigana: "ムセイエキショウ" },
  { name: "無精子症", yomigana: "ムセイシショウ" },
  { name: "その他", yomigana: "ンンン" },
])

FSurgery.create([
  { name: "円錐切除手術", yomigana: "エンスイセツジョシュジュツ" },
  { name: "子宮筋腫", yomigana: "シキュウキンシュ" },
  { name: "子宮内膜症", yomigana: "シキュウナイマクショウ" },
  { name: "子宮内膜ポリープ切除", yomigana: "シキュウナイマクポリープセツジョ" },
  { name: "卵管形成手術(FT)", yomigana: "ランカンケイセイシュジュツ" },
  { name: "卵管切除", yomigana: "ランカンセツジョ" },
  { name: "卵巣嚢腫", yomigana: "ランソウノウシュ" },
  { name: "レーザー蒸散術", yomigana: "レーザージョウサンジュツ" },
  { name: "その他", yomigana: "ンンン" },
])

MSurgery.create([
  { name: "顕微鏡下低位結紮術", yomigana: "ケンビキョウカテイイケッサツジュツ" },
  { name: "精索静脈瘤", yomigana: "セイサクジョウミャクリュウ" },
  { name: "精路再建手術", yomigana: "セイロサイケンシュジュツ" },
  { name: "TESA", yomigana: "テサ" },
  { name: "TESE", yomigana: "テセ" },
  { name: "MESA", yomigana: "メサ" },
  { name: "その他", yomigana: "ンンン" },
])

SairanMedicine.create([
  { name: "hMGテイゾー", yomigana: "エイチエムジー亭ぞー" },
  { name: "hMGフェリング", yomigana: "エイチエムジーフェリング" },
  { name: "hMGフジ", yomigana: "エイチエムジーフジ" },
  { name: "オビドレル", yomigana: "オビドレル" },
  { name: "ガニレスト", yomigana: "ガニレスト" },
  { name: "クロミッド(クロミフェン/セロフェン)", yomigana: "クロミッド" },
  { name: "ゴナピュール", yomigana: "ゴナピュール" },
  { name: "スプレキュア", yomigana: "スプレキュア" },
  { name: "セキソビット", yomigana: "セキソビット" },
  { name: "セトロタイド", yomigana: "セトロタイド" },
  { name: "ナサニール", yomigana: "ナサニール" },
  { name: "フェマーラ(レトロゾール)", yomigana: "フェマーラ" },
  { name: "フォリスチム", yomigana: "フォリスチム" },
  { name: "フォリルモン", yomigana: "フォリルモン" },
  { name: "ブセレキュア", yomigana: "ブセレキュア" },
  { name: "プロギノーバ", yomigana: "プロギノーバ" },
  { name: "ボルタレン", yomigana: "ボルタレン" },
  { name: "レルミナ", yomigana: "レルミナ" },
  { name: "その他", yomigana: "ンンン" },
])

TransferMedicine.create([
  { name: "ウトロゲスタン", yomigana: "ウトロゲスタン" },
  { name: "hCG", yomigana: "エイチシージー" },
  { name: "エストラーナテープ", yomigana: "エストラーナテープ" },
  { name: "エストロジェル", yomigana: "エストロジェル" },
  { name: "ジュリナ", yomigana: "ジュリナ" },
  { name: "ディビゲル", yomigana: "ディビゲル" },
  { name: "デュファストン", yomigana: "デュファストン" },
  { name: "バファリン", yomigana: "バファリン" },
  { name: "プラノバール", yomigana: "プラノバール" },
  { name: "プレマリン", yomigana: "プレマリン" },
  { name: "プロゲストン", yomigana: "プロゲストン" },
  { name: "プロゲステロン", yomigana: "プロゲステロン" },
  { name: "プロベラ", yomigana: "プロベラ" },
  { name: "ルティナス", yomigana: "ルティナス" },
  { name: "ルテウム", yomigana: "ルテウム" },
  { name: "ルトラール", yomigana: "ルトラール" },
  { name: "ワンクリノン", yomigana: "ワンクリノン" },
  { name: "その他", yomigana: "ンンン" },
])

TransferOption.create([
  { name: "アシステッドハッチング(AHA)", yomigana: "アシステッドハッチング" },
  { name: "エンブリオグルー", yomigana: "エンブリオグルー" },
  { name: "シート法(SEET)", yomigana: "シートホウ" },
  { name: "スクラッチング法", yomigana: "スクラッチングホウ" },
  { name: "ヒアルロン酸胚移植用培養液", yomigana: "ヒアルロンサンハイイショクヨウバイヨウエキ" },
  { name: "その他", yomigana: "ンンン" },
])

OtherEffort.create([
  { name: "運動", yomigana: "ウンドウ" },
  { name: "漢方(煎じ薬)", yomigana: "カンポウセンジ" },
  { name: "漢方(エキス剤等)", yomigana: "カンポウエキス" },
  { name: "鍼", yomigana: "ハリ" },
  { name: "鍼灸", yomigana: "シンキュウ" },
  { name: "整体", yomigana: "セイタイ" },
  { name: "骨盤矯正", yomigana: "コツバンキョウセイ" },
  { name: "ヨガ", yomigana: "ヨガ" },
  { name: "ホットヨガ", yomigana: "ホットヨガ" },
  { name: "よもぎ蒸し", yomigana: "ヨモギムシ" },
  { name: "岩盤浴", yomigana: "ガンバンヨク" },
  { name: "ファスティング", yomigana: "ファスティング" },
  { name: "その他", yomigana: "ンンン" },
])

MOtherEffort.create([
  { name: "運動", yomigana: "ウンドウ" },
  { name: "漢方(煎じ薬)", yomigana: "カンポウセンジ" },
  { name: "漢方(エキス剤等)", yomigana: "カンポウエキス" },
  { name: "鍼", yomigana: "ハリ" },
  { name: "鍼灸", yomigana: "シンキュウ" },
  { name: "整体", yomigana: "セイタイ" },
  { name: "骨盤矯正", yomigana: "コツバンキョウセイ" },
  { name: "ヨガ", yomigana: "ヨガ" },
  { name: "ホットヨガ", yomigana: "ホットヨガ" },
  { name: "よもぎ蒸し", yomigana: "ヨモギムシ" },
  { name: "岩盤浴", yomigana: "ガンバンヨク" },
  { name: "ファスティング", yomigana: "ファスティング" },
  { name: "その他", yomigana: "ンンン" },
])

Inspection.create([
  { name: "AMH検査", yomigana: "エーエムエイチケンサ" },
  { name: "黄体ホルモン検査(P4)", yomigana: "オウタイホルモンケンサ" },
  { name: "基礎体温", yomigana: "キソタイオン" },
  { name: "クラミジア抗原", yomigana: "クラミジアコウゲン" },
  { name: "頚管粘液検査", yomigana: "ケイカンネンエキケンサ" },
  { name: "甲状腺機能検査", yomigana: "コウジョウセンキノウケンサ" },
  { name: "抗精子抗体検査", yomigana: "コウセイシコウタイケンサ" },
  { name: "子宮頸がん検査", yomigana: "シキュウケイガンケンサ" },
  { name: "子宮卵管造影", yomigana: "シキュウランカンゾウエイ" },
  { name: "超音波検査", yomigana: "チョウオンパケンサ" },
  { name: "テストステロン検査", yomigana: "テストステロンケンサ" },
  { name: "フーナーテスト", yomigana: "フーナーテスト" },
  { name: "ホルモン値検査(E2･FSH･LH･PRL)", yomigana: "ホルモンチケンサ" },
  { name: "卵管通水検査", yomigana: "ランカンツウスイケンサ" },
  { name: "その他", yomigana: "ンンン" },
])

ClFemaleInspection.create([
  { name: "AMH検査", yomigana: "エーエムエイチケンサ" },
  { name: "黄体ホルモン検査(P4)", yomigana: "オウタイホルモンケンサ" },
  { name: "基礎体温", yomigana: "キソタイオン" },
  { name: "クラミジア抗原", yomigana: "クラミジアコウゲン" },
  { name: "頚管粘液検査", yomigana: "ケイカンネンエキケンサ" },
  { name: "甲状腺機能検査", yomigana: "コウジョウセンキノウケンサ" },
  { name: "抗精子抗体検査", yomigana: "コウセイシコウタイケンサ" },
  { name: "子宮頸がん検査", yomigana: "シキュウケイガンケンサ" },
  { name: "子宮卵管造影", yomigana: "シキュウランカンゾウエイ" },
  { name: "超音波検査", yomigana: "チョウオンパケンサ" },
  { name: "テストステロン検査", yomigana: "テストステロンケンサ" },
  { name: "フーナーテスト", yomigana: "フーナーテスト" },
  { name: "ホルモン値検査(E2･FSH･LH･PRL)", yomigana: "ホルモンチケンサ" },
  { name: "卵管通水検査", yomigana: "ランカンツウスイケンサ" },
  { name: "その他", yomigana: "ンンン" },
])

MaleInspection.create([
  { name: "精液検査", yomigana: "セイエキケンサ" },
  { name: "イムノビーズテスト", yomigana: "イムノビーズテスト" },
  { name: "陰嚢部超音波検査", yomigana: "インノウブチョウオンパケンサ" },
  { name: "SCSA", yomigana: "エスシーエスエー" },
  { name: "クルーガーテスト", yomigana: "" },
  { name: "睾丸触診", yomigana: "コウガンショクシン" },
  { name: "高倍率精子形態検査", yomigana: "コウバイリツセイシケイタイケンサ" },
  { name: "精子生存性検査", yomigana: "セイシセイゾンセイケンサ" },
  { name: "ホルモン検査", yomigana: "ホルモンケンサ" },
  { name: "その他", yomigana: "ンンン" },
])

ClMaleInspection.create([
  { name: "精液検査", yomigana: "セイエキケンサ" },
  { name: "イムノビーズテスト", yomigana: "イムノビーズテスト" },
  { name: "陰嚢部超音波検査", yomigana: "インノウブチョウオンパケンサ" },
  { name: "SCSA", yomigana: "エスシーエスエー" },
  { name: "クルーガーテスト", yomigana: "" },
  { name: "睾丸触診", yomigana: "コウガンショクシン" },
  { name: "高倍率精子形態検査", yomigana: "コウバイリツセイシケイタイケンサ" },
  { name: "精子生存性検査", yomigana: "セイシセイゾンセイケンサ" },
  { name: "ホルモン検査", yomigana: "ホルモンケンサ" },
  { name: "その他", yomigana: "ンンン" },
])

CostBurden.create([
  { name: "自分" },
  { name: "パートナー" },
  { name: "両親" },
  { name: "義両親" },
  { name: "祖父祖母" },
  { name: "親戚" },
  { name: "その他" },
])

FuikuInspection.create([
  { name: "血液凝固異常", yomigana: "ケツエキギョウコイジョウ" },
  { name: "甲状腺機能異常", yomigana: "コウジョウセンキノウイジョウ" },
  { name: "抗リン脂質抗体症候群", yomigana: "コウリンシシツコウタイショウコウグン" },
  { name: "抗リン脂質抗体陽性", yomigana: "コウリンシシツコウタイヨウセイ" },
  { name: "子宮形態異常", yomigana: "シキュウケイタイイジョウ" },
  { name: "夫婦染色体異常", yomigana: "フウフセンショクタイイジョウ" },
  { name: "免疫学的異常", yomigana: "メンエキガクテキイジョウ" },
  { name: "その他", yomigana: "ンンン" },
])

ClSelection.create([
  { name: "自宅から近かったから" },
  { name: "職場から近かったから" },
  { name: "口コミサイトで評価が良かったから" },
  { name: "SNSでの評判を見て" },
  { name: "料金が手頃だったから" },
  { name: "知人から勧められたから" },
  { name: "説明会に参加して決めた" },
  { name: "ホームページをみて" },
  { name: "信頼する医師がいたから" },
  { name: "広告を見て" },
  { name: "その他" },
])