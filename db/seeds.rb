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

Tag.create([
  { tag_name: "自然周期" },
  { tag_name: "アンタゴニスト法" },
  { tag_name: "ショート法" },
  { tag_name: "ロング法" }
])

Supplement.create([
  { name: "ビタミン" },
  { name: "葉酸" },
  { name: "カルニチン" },
])

ScopeOfDisclosure.create([
  { scope: "パートナーまで" },
  { scope: "聞かれたら誰にでもオープン" },
  { scope: "自ら進んで誰にでも開示" },
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
  { name: "バセドウ病" },
  { name: "橋本病" },
])

MDisease.create([
  { name: "糖尿病" },
  { name: "痛風" },
])

FSurgery.create([
  { name: "子宮筋腫" },
  { name: "卵管切除" },
])

MSurgery.create([
  { name: "精索静脈瘤" },
])

SairanMedicine.create([
  { name: "クロミッド(クロミフェン/セロフェン)" },
  { name: "フェマーラ" },
])

TransferMedicine.create([
  { name: "hCG" },
  { name: "プラノバール" },
])

TransferOption.create([
  { name: "エンブリオグルー" },
  { name: "二段階移植" },
  { name: "シート法" },
])

OtherEffort.create([
  { name: "漢方" },
  { name: "鍼灸" },
  { name: "ヨガ" },
  { name: "よもぎ蒸し" },
])

Inspection.create([
  { name: "エラ(ERA)" },
  { name: "エマ(EMMA)" },
  { name: "アリス(ALICE)" },
  { name: "トリオ(TORIO)" },
  { name: "慢性子宮内膜炎(CD138/BCE)" },
  { name: "ERPeak" },
])