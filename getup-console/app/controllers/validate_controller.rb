class ValidateController < ConsoleController
  include Console::UserManagerHelper

  def show
    result = user_manager_account_plan.content
    if result[:primary_address][:is_billing] and result[:billing_address][:name]
      @username = result[:billing_address][:name]
    elsif result[:primary_address][:is_billing] and result[:primary_address][:name]
      @username = result[:primary_address][:name]
    else
      @username = result[:user][:first_name]
    end
  end


  def create
    result = user_manager_validate_account params
    if result.code != 200
      redirect_to validate_path, :flash => {:error => result.message}
    else
      redirect_to account_path, :flash => {:success => I18n.t(:validate_success)}
    end
  end

  def confirm
  end

end
