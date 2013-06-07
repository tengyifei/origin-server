module Console::BillingHelper
  include Console::GetupAdminHelper
  # 
  # 
  def getup_user_capabilities
  	getup_admin_get  session[:authentication].login + '/account/plan/'
  end
end