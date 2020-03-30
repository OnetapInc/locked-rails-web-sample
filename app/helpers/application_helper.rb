# frozen_string_literal: true

module ApplicationHelper
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def clientKey
    'b08627d9d60223979d0cf0e2c7a3d943'
  end

  def client_secret
    'b64f196ebbb5a46bd21aff240d339b42'
  end
end
