class History < ActiveRecord::Base
  
  self.table_name = 'history'

  belongs_to :issue

  #belongs_to :userable, polymorphic: true 
  #safe_attributes :userable_id
  #safe_attributes :userable_type
 
  def self.add_message(issue, author, message)
    note = History.new
    note.issue = issue
    note.author = author.name
    note.notes = message.to_s
    unless note.save!
      raise "Cant save note for issue #{issue.public_id}"
    else 
      history_notification issue, message
    end

  end


  private 

    def self.history_notification(issue, message)
      IssueNotifier.updated(issue,message).deliver
    end
end
