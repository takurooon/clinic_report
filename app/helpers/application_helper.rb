module ApplicationHelper
  def header_link_item(name, path)
    class_name = 'nav-item'
    class_name << ' active' if current_page?(path)

    content_tag :li, class: class_name do
      link_to name, path, class: 'nav-link'
    end
  end

  def resource_name
    :user
  end

  def resource
      @resource ||= User.new
  end

  def devise_mapping
      @devise_mapping ||= Devise.mappings[:user]
  end

  # OGP設定 参考:https://pgmg-rails.com/blogs/16 https://qiita.com/kenzoukenzou104809/items/fe3122abd8e98f9089ba
  def default_meta_tags
    {
      site: '経験をカタチに情報をエールに。不妊治療レポート投稿アプリREPOCO',
      title: 'REPOCO | のこす みえる ふみだせる',
      reverse: true,
      charset: 'utf-8',
      description: '経験をカタチに情報をエールに。REPOCO(レポコ)は不妊治療経験をレポートとして投稿できるアプリ。あなたのレポコが誰かの治療の道を照らす光に。さぁレポコしよう！',
      keywords: 'レポコ, REPOCO, 口コミ, 評判, レビュー, 不妊治療戦士達の通院先と実績',
      canonical: request.original_url,
      separator: '-',
      icon: [
      ],
      og: {
        site_name: "REPOCO | レポコ",
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('home/home_top_img.png'),
        local: 'ja-JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@REPOCO_OFFICIAL',
        image: image_url('home/home_top_img.png'),
        # width: 100,
        # height: 100
      }
    }
  end

  # URLをaタグに変換
  require "uri"
  def text_url_to_link text
    URI.extract(text, ['https']).uniq.each do |url|
      sub_text = ""
      sub_text << "<a href=" << url << " target=\"_blank\">" << url << "</a>"
      text.gsub!(url, sub_text)
    end
    URI.extract(text, ['http']).uniq.each do |url_2|
      sub_text_2 = ""
      sub_text_2 << "<a href=" << url_2 << " target=\"_blank\">" << url_2 << "</a>"
      text.gsub!(url_2, sub_text_2)
    end
    return text
  end

  # svgをviewで表示させる(https://stackoverflow.com/questions/36986925/how-do-i-display-svg-image-in-rails)但し以下のパスはactionフォルダのみに適用される
  def images_action_svg(path)
    File.open("app/assets/images/action/#{path}", "rb") do |file|
      raw file.read
    end
  end
end