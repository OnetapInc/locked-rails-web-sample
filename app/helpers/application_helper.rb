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
    'fadfb50ceb664c2a4701951852db'
  end

  def secureSalt
    'fdd52850738a873b9edbeffa21ea56b6'
  end
end
