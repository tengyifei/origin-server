class PrimaryAddressController < ConsoleController
  include Console::UserManagerHelper

  def edit
    result = user_manager_primary_address
    @address = result.content[:data][0]
  end

  def create
    result = user_manager_primary_address_update params
    redirect_to account_path
  end
end

