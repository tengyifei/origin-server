class BillingController < ConsoleController
  include Console::UserManagerHelper

  def index
      result  = user_manager_billing_history.content
      data = result[:data][0]
      @currency = data[:payment_data].nil? ? '' : data[:payment_data][:preapproval][:currency]
      @history  = data[:history]
  end

  def show
    id = params[:id]
    
    result = user_manager_billing_invoice(id).content
    prices = user_manager_subscription_prices   
    
    @status = result ? true : false
    
    if @status
      result        = result[:data][0]
      @id           = id
      @amount       = result[:invoice][:amount]
      @period       = result[:invoice][:period]
      @payment      = result[:invoice][:payment_data]
      @getup        = result[:invoice][:getup]
      @user         = result[:invoice][:user]
      @address      = result[:invoice][:billing_address]
      @applications = result[:invoice][:applications]
      currency      = result[:invoice][:amount][:total][:currency]

      @prices = user_manager_subscription_prices.content
      
      @price  = @prices.find(currency).next[1]
      @acronym = @price[:GEAR_USAGE][:acronym]
      @unit = {'h' => 'hour', 'm' => 'minute'}
    end
  end
end
