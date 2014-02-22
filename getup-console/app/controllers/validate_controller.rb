class ValidateController < ConsoleController
  include Console::UserManagerHelper

  def show
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
