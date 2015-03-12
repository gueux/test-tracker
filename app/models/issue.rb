require 'securerandom'

class Issue < ActiveRecord::Base
  belongs_to :department
  belongs_to :status, :class_name => 'IssueStatus', :foreign_key => 'status_id'
  belongs_to :author, :class_name => 'Customer', :foreign_key => 'author_id'
  belongs_to :assigned_to, :class_name => 'Staff', :foreign_key => 'assigned_to_id'

  has_many :histories, :class_name => 'History', :dependent => :destroy

  validates_presence_of :public_id, :subject, :department, :author, :status

  validates_length_of :subject, :maximum => 255

  after_create :send_notification


  def description=(arg)
    if arg.is_a?(String)
      arg = arg.gsub(/(\r\n|\n|\r)/, "\r\n")
    end
    #@description = arg
    write_attribute(:description, arg)
  end

  def assigned_to=(asid)
    write_attribute(:assigned_to_id, asid)
  end

  #return customer's info
  def customer_mail
    self.author.mail unless self.author.nil?
  end
 
  def customer_name
    self.author.name unless self.author.nil?
  end

  # Return true if the issue is closed, otherwise false
  def closed?
    self.status.is_closed?
  end

  def open?
    return true unless closed?
  end

  def default_status
    status = IssueStatus.where(is_default: true).take
  end

  def generate_public_id
    public_id = generate_abc_string << '-' << generate_hex_number << '-' << generate_abc_string << '-' << generate_hex_number << '-' << generate_abc_string
    return public_id
  end

  def get_assigned_staff
    if self.assigned_to
      return [self.assigned_to.name, self.assigned_to.id]
    else
      return ['Nobody', nil]
    end
  end

  def get_issue_status
    if self.status
      return [self.status.name, self.status.id]
    else
      return ['Waiting for Staff Response', IssueStatus::STAFF_RESPONSE_STATUS]
    end
  end

  private
  
    def generate_abc_string(length=3)
      chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNOPQRSTUVWXYZ'
      string = ''
      length.times { |i| string << chars[rand(chars.length)] }
      string.upcase
    end

    def generate_hex_number
      SecureRandom.hex(1).to_s.upcase
    end

    def send_notification
      IssueNotifier.created(self).deliver
    end

end
