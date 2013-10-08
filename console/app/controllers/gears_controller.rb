class GearsController < ConsoleController
  include Console::UserManagerHelper

  def show
    @capabilities = user_capabilities :refresh => true

    result = user_manager_account_plan
    @account_plan = result.content
  end

  def create
    redirect_to gears_path if params[:gears] == nil

    result = user_manager_subscription params[:gears]

    if result.code === 302
      redirect_to result.header["location"] 
    else
      redirect_to gears_path, :flash => {:error => result.content[:message]}
    end
  end

  def confirm
    redirect_to gears_path if flash[:payment] == nil
    flash[:payment] = nil

    result = user_manager_subscription_confirm

    if result.code === 302
      redirect_to result.header["location"] 
    else
      if result.content[:status] == 'ok'
        @result = result.content[:data][0]
      else
        redirect_to gears_path, :flash => {:error => result.content[:message]}
      end
    end
  end

end
