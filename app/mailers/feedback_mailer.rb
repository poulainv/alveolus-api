class FeedbackMailer < ActionMailer::Base
  default from: "enjoytheweb2@gmail.com"

  def feedback(feedback)
    recipients  = 'vincent.poulain2@gmail.com'
    subject     = "[Feedback for YourSite] #{feedback.subject}"

    @feedback = feedback
    mail(:to => recipients, :subject => subject)
  end
end
