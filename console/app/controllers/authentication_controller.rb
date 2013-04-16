class AuthenticationController < Console.config.parent_controller.constantize
  include Console::AuthenticationHelper

  layout false

  def signin
    nil
  end

  def signout
  	session[:authentication_login] = nil
    session[:authentication_token] = nil

  	redirect_to signin_path
  end

  def auth
    token = generate_token params[:password]

    secret = Digest::SHA1.hexdigest(Console.config.authentication_session_key)
    session[:authentication_login] = params[:login]
    session[:authentication_token] = ActiveSupport::MessageEncryptor.new(secret).encrypt_and_sign(token)

  	redirect_to applications_path
  end
end


