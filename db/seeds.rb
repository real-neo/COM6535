# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

user_list = [
    ['Bowen', 'Yu', 'UK', 'Sheffield', 'questionyugood@gmail.com', 'Neo', '12345678', true],
    ['Alexis', 'Ioannou', 'Cyprus', 'Limassol', 'ioannou.alexis95@gmail.com', 'acp18ai', 'qweqweqwe', true]
]

user_list.each do |firstname, lastname, country, city, email, username, password, admin|
  User.create(firstname: firstname, lastname: lastname, location: country, city: city, email: email, username: username, password: password, admin: admin, confirmed_at: Time.now)
end

user1 = User.first

post_list = [['This is a post about fitness', 'Describing something about fitness with a lot of words, this should be a bit long', 0],
             ['A post about exercises', 'How do you obtain abs?', 0],
             ['This is a post about diet', 'You should eat healthy to be healthy and fit', 1]]

post_list.each do |title, description, type|
  User.all.each { |user| (1..30).each { |_i| Post.create(user: user, title: title, description: description, post_type: type) } }
end

post1 = Post.first

Like.create(user: user1, post: post1, like: true)

User.all.each do |user|
  user.avatar.purge
end
