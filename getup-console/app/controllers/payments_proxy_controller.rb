class PaymentsProxyController < ConsoleController
  include Console::UserManagerHelper

  layout false

  def confirm
    flash[:payment] = 'confirm'
    redirect_to :controller => 'gears', :action => 'confirm'
  end

  def cancel
    # TODO verify status
    user_manager_subscription_cancel
    redirect_to gears_path, :flash => {:warning => I18n.t(:Subscription_canceled)}
  end

end
