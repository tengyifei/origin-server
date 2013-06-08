class BillingsController < ConsoleController
  include Console::BillingHelper

  def new
    @capabilities = user_capabilities :refresh => true
  	@getup_capabilities = getup_user_capabilities
  end

  def create
    redirect_to new_billing_path if params[:gears] == nil

    result = getup_user_subscription params[:gears]

    if result.content[:status] == 'ok'
      @result = result.content[:data]
    else
      redirect_to new_billing_path, :flash => {:error => result.content[:message]}
    end
  end

  def show
  end
end


