class ConsoleIndexController < ConsoleController
  skip_before_filter :authenticate_user!, :only => :unauthorized

  def index
    redirect_to applications_path
  end
  def unauthorized
    flash[:error] = "Unauthorized"
    redirect_to signin_path
    #render 'console/unauthorized'
  end

  def help
    render 'console/help'
  end
end
