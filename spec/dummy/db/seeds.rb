# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#
unless Rails.env == "test"
  author = HyperKittenMeow::User.create!(
    name: 'Admin',
    email: 'admin@admin.admin',
    password: 'adminadmin', 
    password_confirmation: 'adminadmin'
  )

  post_content = <<-POST
  Hello
  This is a post.
  POST

  HyperKittenMeow::Post.create!(title: 'Test Title', user: author, body: post_content, summary: post_content, published: true)
end
