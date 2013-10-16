class Song < ActiveRecord::Base
  has_many :hype_votes
  has_many :hypers, through: :hype_votes, source: :user
  has_many :hate_votes
  has_many :haters, through: :hate_votes, source: :user
end
