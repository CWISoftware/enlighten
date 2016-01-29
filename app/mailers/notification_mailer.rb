class NotificationMailer < ApplicationMailer
  def notification_email(entity, follower)
    @entity = entity
    @person = follower.person
    mail(to: follower.email, subject: "#{entity.name} has some updates")
  end
end
