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
  { name: "葉酸" },
  { name: "ビタミンC" },
  { name: "ビタミンD" },
  { name: "ビタミンE" },
  { name: "鉄分" },
  { name: "亜鉛" },
  { name: "DHEA" },
  { name: "マカ" },
  { name: "コエンザイム" },
  { name: "L-カルニチン" },
  { name: "イノシトール" },
  { name: "ミトコンドリア" },
  { name: "ラクトフェリン" },
  { name: "プラセンタ" },
  { name: "アルギニン" },
  { name: "L-アルギニン" },
  { name: "レスベラトロール" },
  { name: "メラトニン" },
  { name: "その他" },
])

MSupplement.create([
  { name: "マカ" },
  { name: "亜鉛" },
  { name: "コエンザイム" },
  { name: "ビタミンD" },
  { name: "ビタミンE" },
  { name: "その他" },
])

FDisease.create([
  { name: "多嚢胞性卵巣症候群(PCOS)" },
  { name: "チョコレート嚢胞" },
  { name: "視床下部排卵障害(中枢性の排卵障害)" },
  { name: "下垂体性排卵障害(中枢性の排卵障害)" },
  { name: "無排卵" },
  { name: "無月経" },
  { name: "希発月経" },
  { name: "高プロラクチン血症" },
  { name: "卵巣機能低下" },
  { name: "卵巣嚢胞" },
  { name: "遺残卵胞" },
  { name: "卵巣過剰刺激症候群" },
  { name: "早発性卵巣機能不全" },
  { name: "黄体機能不全" },
  { name: "黄体化非破裂卵胞(LUF)" },
  { name: "頸管粘液分泌不全" },
  { name: "子宮内膜症" },
  { name: "子宮筋腫" },
  { name: "子宮内膜ポリープ" },
  { name: "子宮先天奇形" },
  { name: "子宮発育不全" },
  { name: "子宮内腔癒着症(アッシャーマン症候群)" },
  { name: "子宮腺筋症" },
  { name: "慢性頸管炎" },
  { name: "子宮頸管粘液不全" },
  { name: "クラミジア性卵管炎" },
  { name: "卵管狭窄" },
  { name: "卵管周囲癒着" },
  { name: "卵管狭窄炎" },
  { name: "卵管閉鎖" },
  { name: "卵管留水腫" },
  { name: "抗精子抗体" },
  { name: "内分泌ホルモン異常" },
  { name: "甲状腺機能低下症" },
  { name: "甲状腺機能亢進症" },
  { name: "下垂体線種" },
  { name: "バセドウ病" },
  { name: "橋本病" },
  { name: "乳がん" },
  { name: "卵巣がん" },
  { name: "子宮体がん" },
  { name: "その他" },
])

MDisease.create([
  { name: "勃起障害(ED)" },
  { name: "膣内射精障害" },
  { name: "逆行性射精" },
  { name: "精索静脈瘤" },
  { name: "精路閉鎖" },
  { name: "無精子症" },
  { name: "無精液症" },
  { name: "閉塞性無精子症" },
  { name: "乏精子症" },
  { name: "精子無力症" },
  { name: "奇形精子症" },
  { name: "精液性状低下" },
  { name: "先天性精管欠損" },
  { name: "膿精液症" },
  { name: "クラインフェルター症候群" },
  { name: "糖尿病" },
  { name: "痛風" },
  { name: "その他" },
])

FSurgery.create([
  { name: "子宮筋腫" },
  { name: "子宮内膜症" },
  { name: "卵巣嚢腫" },
  { name: "卵管形成手術(FT)" },
  { name: "卵管切除" },
  { name: "円錐切除手術" },
  { name: "レーザー蒸散術" },
  { name: "子宮内膜ポリープ切除" },
  { name: "その他" },
])

MSurgery.create([
  { name: "精索静脈瘤" },
  { name: "TESE" },
  { name: "TESA" },
  { name: "MESA" },
  { name: "顕微鏡下低位結紮術" },
  { name: "精路再建手術" },
  { name: "その他" },
])

SairanMedicine.create([
  { name: "hMGテイゾー" },
  { name: "hMGフェリング" },
  { name: "hMGフジ" },
  { name: "オビドレル" },
  { name: "ガニレスト" },
  { name: "クロミッド(クロミフェン/セロフェン)" },
  { name: "ゴナピュール" },
  { name: "スプレキュア" },
  { name: "セキソビット" },
  { name: "セトロタイド" },
  { name: "ナサニール" },
  { name: "フェマーラ(レトロゾール)" },
  { name: "フォリスチム" },
  { name: "フォリルモン" },
  { name: "ブセレキュア" },
  { name: "プロギノーバ" },
  { name: "ボルタレン" },
  { name: "レルミナ" },
  { name: "その他" },
])

TransferMedicine.create([
  { name: "ウトロゲスタン" },
  { name: "hCG" },
  { name: "エストラーナテープ" },
  { name: "エストロジェル" },
  { name: "ジュリナ" },
  { name: "ディビゲル" },
  { name: "デュファストン" },
  { name: "バファリン" },
  { name: "プラノバール" },
  { name: "プレマリン" },
  { name: "プロゲストン" },
  { name: "プロベラ" },
  { name: "ルティナス" },
  { name: "ルテウム" },
  { name: "ルトラール" },
  { name: "ワンクリノン" },
  { name: "その他" },
])

TransferOption.create([
  { name: "アシステッドハッチング(AHA)" },
  { name: "エンブリオグルー" },
  { name: "シート法(SEET)" },
  { name: "スクラッチング法" },
  { name: "ヒアルロン酸胚移植用培養液" },
  { name: "その他" },
])

OtherEffort.create([
  { name: "運動" },
  { name: "漢方(煎じ薬)" },
  { name: "漢方(エキス剤等)" },
  { name: "鍼" },
  { name: "鍼灸" },
  { name: "整体" },
  { name: "骨盤矯正" },
  { name: "ヨガ" },
  { name: "ホットヨガ" },
  { name: "よもぎ蒸し" },
  { name: "岩盤浴" },
  { name: "ファスティング" },
  { name: "その他" },
])

MOtherEffort.create([
  { name: "運動" },
  { name: "漢方(エキス剤等)" },
  { name: "鍼" },
  { name: "鍼灸" },
  { name: "整体" },
  { name: "骨盤矯正" },
  { name: "ヨガ" },
  { name: "ホットヨガ" },
  { name: "よもぎ蒸し" },
  { name: "岩盤浴" },
  { name: "ファスティング" },
  { name: "その他" },
])

Inspection.create([
  { name: "AMH検査" },
  { name: "黄体ホルモン検査(P4)" },
  { name: "基礎体温" },
  { name: "クラミジア抗原" },
  { name: "頚管粘液検査" },
  { name: "甲状腺機能検査" },
  { name: "抗精子抗体検査" },
  { name: "子宮頸がん検査" },
  { name: "子宮卵管造影" },
  { name: "超音波検査" },
  { name: "テストステロン検査" },
  { name: "フーナーテスト" },
  { name: "ホルモン値検査(E2/FSH/LH/PRL)" },
  { name: "卵管通水検査" },
  { name: "その他" },
])

ClFemaleInspection.create([
  { name: "AMH検査" },
  { name: "黄体ホルモン検査(P4)" },
  { name: "基礎体温" },
  { name: "クラミジア抗原" },
  { name: "頚管粘液検査" },
  { name: "甲状腺機能検査" },
  { name: "抗精子抗体検査" },
  { name: "子宮頸がん検査" },
  { name: "子宮卵管造影" },
  { name: "超音波検査" },
  { name: "テストステロン検査" },
  { name: "フーナーテスト" },
  { name: "ホルモン値検査(E2/FSH/LH/PRL)" },
  { name: "卵管通水検査" },
  { name: "その他" },
])

MaleInspection.create([
  { name: "精液検査" },
  { name: "イムノビーズテスト" },
  { name: "陰嚢部超音波検査" },
  { name: "SCSA" },
  { name: "クルーガーテスト" },
  { name: "睾丸触診" },
  { name: "高倍率精子形態検査" },
  { name: "精子生存性検査" },
  { name: "ホルモン検査" },
  { name: "その他" },
])

ClMaleInspection.create([
  { name: "精液検査" },
  { name: "イムノビーズテスト" },
  { name: "陰嚢部超音波検査" },
  { name: "SCSA" },
  { name: "クルーガーテスト" },
  { name: "睾丸触診" },
  { name: "高倍率精子形態検査" },
  { name: "精子生存性検査" },
  { name: "ホルモン検査" },
  { name: "その他" },
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
  { name: "凝固異常" },
  { name: "抗リン脂質抗体症候群" },
  { name: "子宮形態異常" },
  { name: "胎児染色体異常" },
  { name: "夫婦染色体異常" },
  { name: "その他" },
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