class Department < ActiveRecord::Base

  has_many :issues
  has_many :staff, :class_name => 'Staff'

  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 30

  def self.default
    first
  end
end
