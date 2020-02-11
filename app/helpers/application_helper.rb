module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "Ruby on Rails Tutorial Sample App"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def clientKey
    'e0abfb988b93f5780f7756bfc2d9'
  end

  def secureSalt
    '0fd6ff304f7d0a32dbad6d8335062995'
  end
end
