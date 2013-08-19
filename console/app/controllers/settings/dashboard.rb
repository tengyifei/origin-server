module Settings
  module Dashboard
    extend ActiveSupport::Concern
    include DomainAware

    def show
      @user = current_user
      user_default_domain rescue nil
      @keys = Key.all :as => @user
      @authorizations = Authorization.all :as => @user
    end

    def password
      @authentication = session[:authentication]
    end

    def update_password
      authentication = session[:authentication]

      old_password = params[:'old-password']
      new_password = params[:password]
      verify_password = params[:'verify-password']

      return redirect_to password_settings_path, :flash => {:error => 'Old password must not be blank.'} unless old_password.present?
      return redirect_to password_settings_path, :flash => {:error => 'New password must not be blank.'} unless new_password.present?
      return redirect_to password_settings_path, :flash => {:error => 'Password doesn\'t match confirmation.'} unless (new_password == verify_password)
      return redirect_to password_settings_path, :flash => {:error => 'Invalid password.'} unless (old_password == authentication.password)

      response = authentication.change_password old_password, new_password
      response_code = response.code.to_i

      flash = if response_code >= 200 and response_code < 400
        {:success => 'Your password has been changed.'}
      else
        {:error => 'Your password cannot be changed'}
      end

      redirect_to settings_path, :flash => flash rescue redirect_to settings_path
    end
  end
end

