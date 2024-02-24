class Article < ApplicationRecord
  has_many :comments, class_name: 'Comment'

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
# if error, remove "class_name: 'Comment'"
# related to comment.rb
