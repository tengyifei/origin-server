module Console::BillingHelper
  include Console::GetupAdminHelper
  # 
  # 
  def getup_user_capabilities
  	response = getup_admin_get session[:authentication].login + '/account/plan/'
  	response.content
  end

  def getup_user_subscription(max_gears)
  	getup_admin_post session[:authentication].login + '/subscription/', :max_gears => max_gears
  end
end