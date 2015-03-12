# Preview all emails at http://localhost:3000/rails/mailers/issue_notifier
class IssueNotifierPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/issue_notifier/created
  def created
    IssueNotifier.created
  end

  # Preview this email at http://localhost:3000/rails/mailers/issue_notifier/updated
  def updated
    IssueNotifier.updated
  end

end
