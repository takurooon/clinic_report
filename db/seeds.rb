# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Tag.create([
  { tag_name: "自然周期" },
  { tag_name: "アンタゴニスト法" },
  { tag_name: "ショート法" },
  { tag_name: "ロング法" }
])

Clinic.create([
  { name: "加藤レディスクリニック" },
  { name: "リプロダクションクリニック東京" },
  { name: "ナチュラルアートクリニック日本橋" },
])


Supplement.create([
  { name: "ビタミン" },
  { name: "葉酸" },
  { name: "カルニチン" },
])

ScopeOfDisclosure.create([
  { scope: "パートナーまで" },
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
  { scope: "聞かれたら誰にでもオープン" },
  { scope: "その他" },
])

FInfertilityFactor.create([
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
  { name: "不育症" },
  { name: "その他" },
])

MInfertilityFactor.create([
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
  { name: "その他" },
])

FDisease.create([
  { name: "あああ" },
  { name: "いいい" },
  { name: "ううう" },
  { name: "えええ" },
  { name: "おおお" },
])

MDisease.create([
  { name: "かかか" },
  { name: "ききき" },
  { name: "くくく" },
  { name: "けけけ" },
  { name: "こここ" },
])

FSurgery.create([
  { name: "さささ" },
  { name: "ししし" },
  { name: "すすす" },
  { name: "せせせ" },
  { name: "そそそ" },
])

MSurgery.create([
  { name: "たたた" },
  { name: "ちちち" },
  { name: "つつつ" },
  { name: "ててて" },
  { name: "ととと" },
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
  { name: "ななな" },
  { name: "ににに" },
  { name: "ぬぬぬ" },
  { name: "ねねね" },
  { name: "ののの" },
])

OtherEffort.create([
  { name: "ななな" },
  { name: "ににに" },
  { name: "ぬぬぬ" },
  { name: "ねねね" },
  { name: "ののの" },
])


Prefecture.create([
  { name: "北海道" },
  { name: "青森県" },
  { name: "岩手県" },
])

City.create([
  { name: "札幌市" },
  { name: "青森県" },
  { name: "岩手県" },
])


Region1.create([
  { name: "東北地方" },
  { name: "関東地方" },
  { name: "中国地方" },
])

Region2.create([
  { name: "北関東" },
  { name: "山陰" },
  { name: "山陽" },
])