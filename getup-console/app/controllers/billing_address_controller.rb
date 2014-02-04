class BillingAddressController < ConsoleController
  include Console::UserManagerHelper

  def edit
    result = user_manager_billing_address
    @address = result.content[:data][0]
  end

  def create
    result = user_manager_billing_address_update params
    redirect_to account_path
  end
end
