module ApplicationHelper
  def full_title(page_title = '')
    base_title = I18n.t('defaults.title')

    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def form_input_class
    "bg-gray-50 border border-gray-300 text-gray-900 sm:text-sm rounded-lg focus:ring-blue-500 focus:border-blue-500 block w-full px-3 py-2 dark:bg-gray-700 dark:border-gray-600 dark:placeholder-gray-400 dark:text-white dark:focus:ring-blue-500 dark:focus:border-blue-500"
  end

  def form_date_class
    "text-center #{form_input_class} md:w-auto"
  end

  def form_select_class
    "text-center #{form_input_class}"
  end

  def default_meta_tags
    {
      site: I18n.t('defaults.site'),
      title: I18n.t('defaults.title'),
      description: I18n.t('defaults.description'),
      keywords: '反抗期 PDF, 反抗期 反抗期届, 反抗期 ソフト, 反抗期 届け、反抗期, REBELLION NOTICE, LITTLE REBELLION, notification, a rebellion period, 叛乱通知',
      charset: 'UTF-8',
      icon: [
        { href: image_url('children_crossing.png') },
        { href: image_url('children_crossing.png'), rel: 'apple-touch-icon', sizes: '180x180', type: 'img/png' },
      ],
      og: {
        site_name: I18n.t('defaults.site'),
        title: I18n.t('defaults.title'),
        description: I18n.t('defaults.description'), 
        type: 'website',
        url: request.original_url,
        image: image_url('ogp.png'),
        locale: { ja: 'ja_JP', en: 'en_US', zh: 'zh_CN' }[I18n.locale],
      },
      twitter: {
        card: 'summary_large_image',
        site: Rails.application.config.x.site.twitter_handle,
      }
    }
  end
end
