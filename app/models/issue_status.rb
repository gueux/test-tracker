class IssueStatus < ActiveRecord::Base

  STAFF_RESPONSE_STATUS = 1
  ON_HOLD_STATUS = 3

  before_destroy :check_status_issues
  
  after_save     :update_default

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, :maximum => 30
 
  def update_default
    IssueStatus.where(['id <> ?', id]).update_all({:is_default => false}) if self.is_default?
  end

  def self.default
    where(:is_default => true).first
  end

  def check_status_issues
    raise "Can't delete status because there are issues assigned with it" if Issue.where(:status_id => id).any?
  end
end
