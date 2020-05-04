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
    prefecture_id: row['prefecture_id'],
    city_id: row['city_id']
  )
end

SSelectionMethod.create([
  { name: "不明" },
  { name: "IMSI(イムジー)" },
  { name: "Zymot(ザイモット)"},
  { name: "SpermSlow(スパムスロー)"},
])

Tag.create([
  { tag_name: "自然周期" },
  { tag_name: "アンタゴニスト法" },
  { tag_name: "ショート法" },
  { tag_name: "ロング法" },
])

Supplement.create([
  { name: "特になし" },
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
])

ScopeOfDisclosure.create([
  { scope: "自ら進んで誰にでもオープン" },
  { scope: "聞かれたら誰にでもオープン" },
  { scope: "パートナー" },
  { scope: "両親" },
  { scope: "兄弟/姉妹" },
  { scope: "義理の両親" },
  { scope: "義理の兄弟/姉妹" },
  { scope: "その他の親戚" },
  { scope: "親友" },
  { scope: "友人" },
  { scope: "同僚" },
  { scope: "上司" },
  { scope: "部下" },
])

FInfertilityFactor.create([
  { name: "特になし" },
  { name: "原因不明" },
  { name: "多嚢胞性卵巣症候群(PCOS)" },
  { name: "視床下部排卵障害(中枢性の排卵障害)" },
  { name: "下垂体性排卵障害(中枢性の排卵障害)" },
  { name: "高プロラクチン血症" },
  { name: "卵巣機能低下" },
  { name: "早発性卵巣機能不全" },
  { name: "黄体機能不全" },
  { name: "黄体化非破裂卵胞(LUF)" },
  { name: "頸管粘液分泌不全" },
  { name: "子宮内膜症" },
  { name: "子宮筋腫" },
  { name: "子宮内膜ポリープ" },
  { name: "子宮奇形" },
  { name: "子宮発育不全" },
  { name: "子宮内腔癒着症(アッシャーマン症候群)" },
  { name: "子宮腺筋症" },
  { name: "クラミジア性卵管炎" },
  { name: "卵管周囲炎" },
  { name: "卵管(狭窄)癒着" },
  { name: "抗精子抗体" },
  { name: "内分泌ホルモン異常" },
])

MInfertilityFactor.create([
  { name: "特になし" },
  { name: "原因不明" },
  { name: "勃起障害(ED)" },
  { name: "膣内射精障害" },
  { name: "逆行性射精" },
  { name: "精索静脈瘤" },
  { name: "無精子症" },
  { name: "無精液症" },
  { name: "閉塞性無精子症" },
  { name: "乏精子症" },
  { name: "精子無力症" },
  { name: "精液性状低下" },
  { name: "先天性精管欠損" },
  { name: "膿精液症" },
  { name: "クラインフェルター症候群" },
])

FDisease.create([
  { name: "特になし" },
  { name: "バセドウ病" },
  { name: "橋本病" },
])

MDisease.create([
  { name: "特になし" },
  { name: "糖尿病" },
  { name: "痛風" },
])

FSurgery.create([
  { name: "特になし" },
  { name: "子宮筋腫" },
  { name: "子宮内膜症" },
  { name: "卵巣嚢腫" },
  { name: "卵管切除" },
])

MSurgery.create([
  { name: "特になし" },
  { name: "精索静脈瘤" },
])

SairanMedicine.create([
  { name: "クロミッド(クロミフェン/セロフェン)" },
  { name: "hMGフェリング" },
  { name: "hMGフジ" },
  { name: "hMGテイゾー" },
  { name: "フェマーラ(レトロゾール)" },
  { name: "ナサニール" },
  { name: "ブセレキュア" },
  { name: "スプレキュア" },
  { name: "オビドレル" },
  { name: "セキソビット" },
  { name: "ゴナピュール" },
  { name: "フォリルモン" },
  { name: "フォリスチム" },
  { name: "ガニレスト" },
  { name: "セトロタイド" },
  { name: "レルミナ" },
  { name: "ボルタレン" },
])

TransferMedicine.create([
  { name: "hCG" },
  { name: "プラノバール" },
  { name: "エストラーナテープ" },
  { name: "ジュリナ" },
  { name: "ディビゲル" },
  { name: "プレマリン" },
  { name: "プロゲストン" },
  { name: "ルトラール" },
  { name: "デュファストン" },
  { name: "プロベラ" },
  { name: "ルティナス" },
  { name: "ワンクリノン" },
  { name: "ルテウム" },
  { name: "ウトロゲスタン" },
])

TransferOption.create([
  { name: "特になし" },
  { name: "シート法(SEET)" },
  { name: "エンブリオグルー" },
  { name: "AHA(アシステッドハッチング)" },
  { name: "スクラッチング法" },
])

OtherEffort.create([
  { name: "特になし" },
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
])

Inspection.create([
  { name: "基礎体温" },
  { name: "AMH検査" },
  { name: "ホルモン値検査(E2/FSH/LH/P)" },
  { name: "テストステロン検査" },
  { name: "プロラクチンホルモン検査" },
  { name: "子宮卵管造影" },
  { name: "卵管通水検査" },
  { name: "超音波検査" },
  { name: "頚管粘液検査" },
  { name: "フーナーテスト" },
  { name: "子宮頸がん検査" },
  { name: "抗精子抗体検査" },
  { name: "クラミジア抗原" },
  { name: "甲状腺機能検査" },
])