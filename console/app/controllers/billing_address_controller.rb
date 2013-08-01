class BillingAddressController < ConsoleController
  include Console::UserManagerHelper

  def edit
  	result = user_manager_billing_address
  	@address = result.content[:data][0]
  end

  def create
  	result = user_manager_billing_address_update params[:country_code], params[:state], params[:city], params[:line1], params[:line2], params[:postal_code], params[:phone], params[:cpf], params[:cnpj]

  	print result.to_yaml
  	redirect_to account_path
  end
end
