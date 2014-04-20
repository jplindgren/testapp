include ApplicationHelper

def sign_in(user, options = {})
  if options[:no_capybara]
    # Sign in when not using Capybara.
    remember_token = User.new_remember_token
    cookies[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
  else
    visit signin_path
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password
    click_button I18n.t("sessions.new.submit")
  end
end

def fill_in_user(values)
	fill_in I18n.t("activerecord.attributes.user.name"),    with: values[:name]
  fill_in I18n.t("activerecord.attributes.user.email"),    with: values[:email]
  fill_in I18n.t("activerecord.attributes.user.password"), with: values[:password]
  fill_in I18n.t("activerecord.attributes.user.password_confirmation"), with: values[:password_confirmation]
end