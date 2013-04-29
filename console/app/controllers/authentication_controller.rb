class AuthenticationController < Console.config.parent_controller.constantize
  layout false

  def signin
  end

  def signout
    reset_session

    redirect_to signin_path
  end

  def auth
    authentication = Authentication.new params[:login], params[:password]
    session[:authentication] = authentication

  	redirect_to applications_path
  end

  def reset
  end

  def change_password
    session[:token] = params[:token]
  end

  def update_password
    Authentication.update_password params[:password], session[:token]
    flash[:success] = "New password saved."

    redirect_to signin_path    
  end

  def send_token
    Authentication.reset_password params[:login]
    flash[:success] = "Password reset requested."

    redirect_to signin_path
  end
end


