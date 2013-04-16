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
end


