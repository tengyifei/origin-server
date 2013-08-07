module Console::UserManagerHelper
  include Console::UserManagerApiHelper
  # 
  # 
  def user_manager_account_plan
  	user_manager_get session[:authentication].login + _url('account_plan')
  end

  def user_manager_account_password_change(login, password, new_password)
    user_manager_post login + _url('account_password_change'), :oldpassword => password, :password1 => new_password, :password2 => new_password
  end

  def user_manager_account_password_reset(email)
    user_manager_post _url('account_password_reset'), :email => email
  end

  def user_manager_account_password_reset_key(token, password)
    user_manager_post _url('account_password_reset_key') + token + "/", :password1 => password, :password2 => password    
  end

  def user_manager_subscription(max_gears)
  	user_manager_post session[:authentication].login + _url('subscription'), :max_gears => max_gears
  end

  def user_manager_subscription_confirm
    user_manager_get session[:authentication].login + _url('subscription_confirm')
  end

  def user_manager_subscription_cancel
    user_manager_get session[:authentication].login + _url('subscription_cancel')
  end
  
  def user_manager_subscription_prices
    user_manager_get session[:authentication].login + _url('subscription_prices')
  end

  def user_manager_billing_address
    user_manager_get session[:authentication].login + _url('billing_address')
  end

  def user_manager_billing_address_update(country_code, state, city, line1, line2, postal_code, phone)
    user_manager_post session[:authentication].login + _url('billing_address'), :country_code => country_code, :state => state, :city => city, :line1 => line1, :line2 => line2, :postal_code => postal_code, :phone => phone
  end
  
  def user_manager_billing_history
    user_manager_get session[:authentication].login + _url('billing_history')
  end
  
  def user_manager_billing_invoice(id)
    user_manager_get session[:authentication].login + _url('billing_invoice') + id + '/'
  end

  private
    def _url(url)
      Console.config.api[:user_manager][url]
    end  
end