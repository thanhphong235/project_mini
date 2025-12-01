class ContactsController < ApplicationController
  def index
    # hiển thị form liên hệ
  end

  def create
    # Ví dụ: chỉ flash message, chưa gửi email
    name = params[:name]
    email = params[:email]
    subject = params[:subject]
    message = params[:message]

    # TODO: xử lý gửi email hoặc lưu DB
    flash[:notice] = "Thank you #{name}, your message has been sent!"
    redirect_to contacts_path
  end
end
