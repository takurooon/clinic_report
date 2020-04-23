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
      site: '不妊治療レポート投稿サービス',
      title: 'REPOCO',
      reverse: true,
      charset: 'utf-8',
      description: '不妊治療の通院先と実績をレポートとして投稿しよう！',
      keywords: '不妊治療,体外受精,顕微受精',
      canonical: request.original_url,
      separator: '-',
      icon: [
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('home/home_top_img.png'),
        local: 'ja-JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@pocoloooog',
        image: image_url('home/home_top_img.png'),
        width: 100,
        height: 100
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
    return text
  end
end
