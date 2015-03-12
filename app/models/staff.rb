class Staff < ActiveRecord::Base

  self.table_name = 'staff'

  has_many :issues
  has_one :department

  validates_presence_of :name, :mail, :hashed_password, :department_id
  validates_uniqueness_of :mail, :if => Proc.new { |user| user.mail_changed? && user.mail.present? }, :case_sensitive => false

  validates_format_of :mail, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i, :allow_blank => false
  
  after_destroy :ensure_last_user_remains

  def initialize(atr=nil)
    super
    self.hashed_password = Staff.hash_password(atr[:hashed_password]) if atr && atr[:hashed_password]
  end

  def admin?
    self.admin
  end

  def check_password?(password)
    check_password(password)
  end

  #def self.current
  #  byebug
  #  current = RequestStore.store[:current_user]
  #  return Staff.find(current) unless current.nil?
  #end
 
  private 

  def self.login(login, password)
    login = login.to_s
    password = password.to_s

    return nil if login.empty? || password.empty?
    staff = find_by_login(login)
    if staff
      return nil unless staff.check_password?(password)
    end
    return staff
  end

  def self.hash_password(password)
    Digest::SHA1.hexdigest(password || "")
  end

  def check_password(password)
    Staff.hash_password("#{password}") == hashed_password
  end
  
  def ensure_last_user_remains
    if Staff.count.zero?
      raise 'The last user cant be deleted'
    end
  end
end

class Nobody < Staff
  def initialize(atr=nil)
    super
    self.name = 'Nobody'
  end
end
