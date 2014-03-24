class Album < ActiveRecord::Base
  has_many :songs
  has_attached_file :cover, :styles => { :default => "300x300#", :thumb => "80x80#" }, :default_url => "default.png"
  validates_attachment :cover, :content_type => { :content_type => ["image/jpg", "image/gif", "image/png", "image/jpeg"] }
end
