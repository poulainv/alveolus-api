class FeedbackMailer < ActionMailer::Base
  default from: "contact@alveolus.fr"

  def feedback(feedback)
    recipients  = 'vincent.poulain2@gmail.com'
    subject     = "[Feedback for Alveolus] #{feedback.subject}"

    @feedback = feedback
    mail(:to => recipients, :subject => subject)
  end
end
