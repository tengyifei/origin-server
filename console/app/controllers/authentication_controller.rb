class AuthenticationController < Console.config.parent_controller.constantize
  include Console::AuthenticationHelper

  layout false

  def signin
    reset_session
  end

  def signout
    redirect_to signin_path

    #reset_session

    #session.delete :authentication_token
    #session.delete :authentication_login

    #clear session
    #session.delete :domain
  end

  def auth
    authentication = Authentication.new :login => params[:login]
    authentication.generate_token params[:password]

    session[:authentication] = authentication

    logger.debug(session[:authentication])

  	redirect_to applications_path
  end
end


