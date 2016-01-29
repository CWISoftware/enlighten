class NotificationMailer < ApplicationMailer
  def notification_email(entity)
    @entity = entity
    followers = entity.followers.includes(:person).where(Person.where(notification: true)).all
    emails = followers.pluck(:email)
    mail(bcc: emails, subject: 'test')
  end
end
