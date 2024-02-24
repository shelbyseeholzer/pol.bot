# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

article1 = Article.new(title: 'Hello Rails', body: 'I am on Rails!')
article1.save

article2 = Article.new(title: 'Article 2', body: 'This is the second article. I really think there should be a better way to save
my articles than this. I dont know that yet, I am just learning. Plust I cant even use apostrophe ')
article2.save

article3 = Article.new(title: 'Article 3', body: 'This is the third article.')
article3.save
