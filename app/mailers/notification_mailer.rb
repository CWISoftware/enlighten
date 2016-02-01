class NotificationMailer < ApplicationMailer
  def notification_email(followed, follower)
    @followed = followed
    @follower_person = follower.person
    mail(to: follower.email, subject: "#{followed.name} has some updates")
  end
end
