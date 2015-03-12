class SessionsController < ApplicationController

  skip_before_action :authorize
  # GET /sessions/new
  def new
  end

  # POST /sessions
  def create
    staff = authenticate(params[:login], params[:password])
    unless staff.nil?
      session[:current_user] = staff.id
      #RequestStore.store[:current_user] = staff
      redirect_to manage_url
    else 
      redirect_to login_url, alert: 'Invalid Login or Password'
    end
  end

  # DELETE /sessions/1
  def destroy
    #RequestStore.store[:current_user] = nil
    session[:current_user] = nil
    redirect_to login_url, notice: 'Logged Out'
  end

  private 

  def authenticate(login, password)
    Staff.login(login, password)
  end

end
