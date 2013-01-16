ActionMailer::Base.smtp_settings = {
   :address              => "smtp.gmail.com",
   :port                 => 587,
   :user_name            => "EnjoyTheWeb2@gmail.com",
   :domain            => "gmail.com",
   :password             => "quenelle",
   :authentication       => "plain",
   :enable_starttls_auto => true
}

