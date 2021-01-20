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
    name: row['name'],
    name_alphabet: row['name_alphabet'],
  )
end

CSV.foreach('db/csv/prefecture.csv', headers: true) do |row|
  Prefecture.create(
    name: row['name'],
    name_alphabet: row['name_alphabet'],
    region1_id: row['region1_id']
  )
end

CSV.foreach('db/csv/city.csv', headers: true) do |row|
  City.create(
    name: row['name'],
    name_alphabet: row['name_alphabet'],
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
    g_map: row['g_map'],
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

TransferOption.create([
  { name: "2段階移植", yomigana: "ニダンカイイショク", number: 101 },
  { name: "複数胚移植", yomigana: "フクスウハイイショク", number: 102 },
  { name: "アシステッドハッチング(AHA)", yomigana: "アシステッドハッチング", number: 103 },
  { name: "hCG注射", yomigana: "エイチシージーチュウシャ", number: 104 },
  { name: "エンブリオグルー", yomigana: "エンブリオグルー", number: 105 },
  { name: "シート法(SEET)", yomigana: "シートホウ", number: 106 },
  { name: "スクラッチング法", yomigana: "スクラッチングホウ", number: 107 },
  { name: "ヒアルロン酸胚移植用培養液", yomigana: "ヒアルロンサンハイイショクヨウバイヨウエキ", number: 108 },
  { name: "その他", yomigana: "ンンン", number: 999 },
])

FuikuInspection.create([
  { name: "血液凝固異常", yomigana: "ケツエキギョウコイジョウ", number: 101 },
  { name: "甲状腺機能異常", yomigana: "コウジョウセンキノウイジョウ", number: 102 },
  { name: "抗リン脂質抗体症候群", yomigana: "コウリンシシツコウタイショウコウグン", number: 103 },
  { name: "抗リン脂質抗体陽性", yomigana: "コウリンシシツコウタイヨウセイ", number: 104 },
  { name: "子宮形態異常", yomigana: "シキュウケイタイイジョウ", number: 105 },
  { name: "夫婦染色体異常", yomigana: "フウフセンショクタイイジョウ", number: 106 },
  { name: "免疫学的異常", yomigana: "メンエキガクテキイジョウ", number: 107 },
  { name: "その他", yomigana: "ンンン", number: 999 },
])

ClSelection.create([
  { name: "自宅からの通いやすさ", number: 101 },
  { name: "職場からの通いやすさ", number: 102 },
  { name: "口コミサイトでの評価をみて", number: 103 },
  { name: "SNSでの評判をみて", number: 104 },
  { name: "知人が通っていたから", number: 105 },
  { name: "知人からの勧め", number: 106 },
  { name: "パートナーからの勧め", number: 107 },
  { name: "家族や親戚からの勧め", number: 108 },
  { name: "信頼する医師がいたから", number: 109 },
  { name: "説明会に参加して納得したから", number: 110 },
  { name: "ホームページをみて", number: 111 },
  { name: "広告を見て", number: 112 },
  { name: "その他", number: 999 },
])

PgEplenishment.create([
  { name: "なし", yomigana: "ンンン", number: 101 },
  { name: "内服", yomigana: "ナイフク", number: 102 },
  { name: "膣剤", yomigana: "チツザイ", number: 103 },
  { name: "注射", yomigana: "チュウシャ", number: 104 },
  { name: "塗布薬(ジェルなど)", yomigana: "トフヤク", number: 105 },
  { name: "貼付薬(テープなど)", yomigana: "テンプヤク", number: 106 },
])

FFuninFactor.create([
  { name: "原因不明", yomigana: "ゲンインフメイ", number: 101 },
  { name: "子宮筋腫", yomigana: "シキュウキンシュ", number: 102 },
  { name: "子宮内膜症(子宮腺筋症含む)", yomigana: "シキュウナイマクショウ", number: 103 },
  { name: "PCOS(多嚢胞性卵巣症候群)", yomigana: "タノウホウセイランソウショウコウグン", number: 104 },
  { name: "卵管性不妊", yomigana: "ランカンセイフニン", number: 105 },
  { name: "その他", yomigana: "ンンン", number: 999 },
])