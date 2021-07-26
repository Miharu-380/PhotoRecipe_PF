module ApplicationHelper
  def default_meta_tags
    {
      site: 'Smaphoto Recipe!',
      title: 'Smaphoto Recipe!',
      reverse: true,
      charset: 'utf-8',
      description: 'おしゃれな写真が撮れたら共有！レシピを使って素敵な写真づくりをしよう。',
      keywords: 'スマホ,写真,おしゃれ,映える',
      noindex: ! Rails.env.production?,
      canonical: request.original_url,
      separator: '|',
      icon: [
        { href: image_url('favicon.png') },
        { href: image_url('favicon.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'image/jpg' },
      ],
      og: {
        site_name: :site,
        title: :title,
        description: :description,
        type: 'website',
        url: request.original_url,
        image: image_url('smaphotorecipe.jpg'),
        locale: 'ja_JP',
      },
      twitter: {
        card: 'summary_large_image',
        site: '@3_8___0',
      }
    }
  end
end
