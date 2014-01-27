class BillingController < ConsoleController
  include Console::UserManagerHelper
  include Console::CountryHelper

  def index
      result  = user_manager_billing_history.content
      data = result[:data][0]
      @currency = data[:payment_data].nil? ? '' : data[:payment_data][:currency]
      @history  = data[:history]
  end

  def show
    id = params[:id]

    begin
      result = user_manager_billing_invoice(id).content
      raise result[:data][0] if result[:status] != 'ok'
    rescue Exception => e
      return redirect_to billing_index_path, :flash => {:error => e.message}
    end

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
      if result[:invoice].has_key? :prices
        @prices       = result[:invoice][:prices]
      else
        @prices       = user_manager_subscription_prices.content
      end
      @price        = @prices.find(result[:invoice][:amount][:total][:currency]).next[1]
      @acronym      = @price[:GEAR_USAGE][:acronym]
      @unit         = {'h' => 'hour', 'd' => 'day', 'm' => 'month', 'g' => 'gigabyte'}

      @getup[:country_name]   = country_name(@getup[:country_code])
      @address[:country_name] = country_name(@address[:country_code])
    end
  end
end
