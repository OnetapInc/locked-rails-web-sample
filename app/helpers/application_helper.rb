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
    '972e0bf855e95b36cd6c832e4de5'
  end

  def secureSalt
    '45770fd6be933cb220f7f6630ccb6007'
  end
end
