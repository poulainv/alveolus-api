ActionMailer::Base.smtp_settings = {
   :address              => "smtp.gmail.com",
   :port                 => 587,
   :user_name            => "enjoytheweb2@gmail.com",
   :domain            => "enjoytheweb2",
   :password             => "quenelle",
   :authentication       => "plain",
   :enable_starttls_auto => true
}

