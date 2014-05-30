class Post < ActiveRecord::Base
  validates :title, :storyurl, :presence => true 
  validates :title, :uniqueness => true
end
