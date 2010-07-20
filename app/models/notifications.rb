class Notifications < ActionMailer::Base
  

  def send_notification_mail(first_name, last_name, email, sent_at = Time.now)
    subject 'Signup Notification Mail'
    recipients email
    from 'jagira@gmail.com'
    sent_on sent_at
    body :name => first_name + " " + last_name
    headers {}
    content_type "text/html"
  end

  def forgot_password(email, first_name, last_name, password, sent_at = Time.now)
    subject 'New Password for your AskMe Account'
    recipients email
    from 'jagira@gmail.com'
    sent_on sent_at
    body :name => first_name + " " + last_name
    body :password => password
    content_type "text/html"
  end

end