class Customer < ActiveRecord::Base
  has_many :issues
  

  validates_presence_of :name, :mail
  validates_uniqueness_of :mail

  validates_format_of :mail, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => false
  
end
