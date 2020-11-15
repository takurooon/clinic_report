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

TransferOption.create([
  { name: "アシステッドハッチング(AHA)", yomigana: "アシステッドハッチング" },
  { name: "エンブリオグルー", yomigana: "エンブリオグルー" },
  { name: "シート法(SEET)", yomigana: "シートホウ" },
  { name: "スクラッチング法", yomigana: "スクラッチングホウ" },
  { name: "ヒアルロン酸胚移植用培養液", yomigana: "ヒアルロンサンハイイショクヨウバイヨウエキ" },
  { name: "その他", yomigana: "ンンン" },
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