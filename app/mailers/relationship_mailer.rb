class RelationshipMailer < ActionMailer::Base
  default from: "jpdesenvolver@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.relationship_mailer.new_follower_notification.subject
  #
  def new_follower_notification followed, follower
    @follower =  follower

    mail(:to => "#{followed.name} <#{followed.email}>", :subject => "#{follower.name} is following you!")
  end
end
