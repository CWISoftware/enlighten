class NotificationJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    entity = args.first
    followers = entity.followers.includes(:person).where(Person.where(notification: true)).all
    followers.each do |follower|
      NotificationMailer.notification_email(entity, follower).deliver_later
    end
  end
end
