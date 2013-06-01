ActionMailer::Base.smtp_settings = {
   :address              => "smtp.alveolus.fr",
   :port                 => 587,
   :user_name            => "contact@alveolus.fr",
   :domain            => "alveolus.fr",
   :password             => "alveolus60",
   :authentication       => "plain",
   :enable_starttls_auto => true
}

