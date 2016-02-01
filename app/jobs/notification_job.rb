class NotificationJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    entity = args.first
    followers = entity.followers.joins(:person).where(people: { notification: true })
    followers.each do |follower|
      NotificationMailer.notification_email(entity, follower).deliver_later
    end
  end
end
