class IssueNotifier < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.issue_notifier.created.subject
  #
  def created(issue)
    @issue = issue

    mail to: issue.customer_mail, subject: issue.subject
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.issue_notifier.updated.subject
  #
  def updated(issue, message)
    @issue = issue
    @message = message

    mail to: issue.customer_mail, subject: issue.subject
  end
end
