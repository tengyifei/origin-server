class BillingController < ConsoleController
  include Console::BillingHelper

  def new
  	capabilities = getup_user_capabilities
    print capabilities.to_yaml
  end
  
  def create
    #authentication = Registration.new ???????
    #redirect_to applications_path
  end

  def show
  end
end


