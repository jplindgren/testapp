require 'development_mail_interceptor'

#ActionMailer::Base.default_url_options[:host] = "localhost:3000" unless Rails.env.production?
ActionMailer::Base.default_url_options[:host] = Rails.env.production? ? 
																											"microtwitterjp.herokuapp.com" : "localhost:3000"

# using DevelopmentMailInterceptor (inside lib) to intercept every email message in a develop enviroment
ActionMailer::Base.register_interceptor(DevelopmentMailInterceptor) if Rails.env.development?

unless Rails.env.test?
	emails_settings = YAML::load(File.open("#{Rails.root}/config/email.yml"))
	ActionMailer::Base.smtp_settings = emails_settings[Rails.env] unless emails_settings[Rails.env].nil?
end

