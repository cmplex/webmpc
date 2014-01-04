class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :hype_votes
  has_many :hyped_songs, through: :hype_votes, source: :song
  has_many :hate_votes
  has_many :hated_songs, through: :hate_votes, source: :song

	def online?
		current_sign_in_at < 2.hours.ago
	end
end
