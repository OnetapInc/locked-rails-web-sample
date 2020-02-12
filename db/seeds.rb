# frozen_string_literal: true

Micropost.delete_all
User.delete_all
4.times do |index|
  hash = SecureRandom.hex(4)
  user = User.find_or_initialize_by(
    name: "Locked Demo #{index}(#{hash})",
    email: "takeda+#{hash}@locked.jp",
    phone_number: '09014201224',
    activated: true
  )
  user.save!(
    password: 'onetap0507',
    password_confirmation: 'onetap0507'
  )
end
User.update_all(activated: true, activated_at: Time.zone.now)

users = User.all
user  = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }

50.times do
  content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: content) }
end
