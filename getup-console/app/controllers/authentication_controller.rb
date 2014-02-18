class AuthenticationController < Console.config.parent_controller.constantize
  include Console::UserManagerHelper
  include Console::HelpHelper
  include Console::LanguageHelper

  layout 'authentication'

  before_filter :set_locale

  def signin
  end

  def signout
    reset_session

    redirect_to signin_path
  end

  def auth
    authentication = Authentication.new
    authentication.generate params[:login], params[:password]

    session[:authentication] = authentication
    session[:lang] = user_manager_account_lang

    redirect_to applications_path
  end

  def reset
  end

  def change_password
    session[:token] = params[:token]
  end

  def update_password
    if params[:password] != params[:'verify-password']
      redirect_to signin
    end

    authentication = Authentication.new
    updated = authentication.update_password params[:password], session[:token]

    if updated
      flash[:success] = I18n.t(:new_pass_saved)
    else
      flash[:error] = I18n.t(:error_saving_pass)
    end

    redirect_to signin_path    
  end

  def send_token
    authentication = Authentication.new
    begin
      authentication.reset_password params[:login]
      flash[:success] = I18n.t(:reset_password_flash)
    rescue
      flash[:error] = I18n.t(:reset_password_error, {email: support_email})
    end
    redirect_to signin_path
  end
end
