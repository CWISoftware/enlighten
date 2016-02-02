class NotificationJob < ActiveJob::Base
  queue_as :mailers

  def perform(*args)
    followed = args.first
    followers = followed.followers.joins(:person).where(people: { notification: true })
    followers.each do |follower|
      NotificationMailer.notification_email(followed, follower).deliver_later
    end
  end
end
