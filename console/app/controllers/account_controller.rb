class AccountController < ConsoleController
  def show
  	@capabilities = user_capabilities :refresh => true
  end
end
