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

    def update_language
      lang = params[:lang][:select]
      user_manager_account_lang_change lang
      session[:lang] = lang
      redirect_to settings_path
    end

    def password
      @authentication = session[:authentication]
    end

    def update_password
      authentication = session[:authentication]

      old_password = params[:'old-password']
      new_password = params[:password]
      verify_password = params[:'verify-password']

      return redirect_to password_settings_path, :flash => {:error => I18n.t(:passwd_change_error_1)} unless old_password.present?
      return redirect_to password_settings_path, :flash => {:error => I18n.t(:passwd_change_error_2)} unless new_password.present?
      return redirect_to password_settings_path, :flash => {:error => I18n.t(:passwd_change_error_3)} unless (new_password == verify_password)
      return redirect_to password_settings_path, :flash => {:error => I18n.t(:passwd_change_error_4)} unless (old_password == authentication.password)

      response = authentication.change_password old_password, new_password
      response_code = response.code.to_i

      flash = if response_code >= 200 and response_code < 400
        {:success => I18n.t(:passwd_changed)}
      else
        {:error => I18n.t(:passwd_change_error_4)}
      end

      redirect_to settings_path, :flash => flash rescue redirect_to settings_path
    end
  end
end

