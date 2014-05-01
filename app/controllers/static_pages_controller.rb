class StaticPagesController < ApplicationController
  def home
  	if signed_in? 
  		@micropost = current_user.microposts.build 
  		@feed_items = current_user.feed.paginate(page: params[:page])
  	end
  	
  end

  def help
  end

  def about
  end

  def contact
  end

  def send_mail
    name = params[:name]
    email = params[:email]
    body = params[:message]
    ContactMailer.contact_email(name, email, body).deliver
    redirect_to contact_path, notice: 'Message sent'
  end
end
