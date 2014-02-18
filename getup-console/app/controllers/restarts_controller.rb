class RestartsController < ConsoleController

  def show
    user_default_domain
    @application = @domain.find_application params[:application_id]
  end

  def update
    user_default_domain
    @application = @domain.find_application params[:application_id]

    @application.restart!

    message = @application.messages.first || I18n.t(:app_restarted, app: @application.name)
    redirect_to @application, :flash => {:success => message}
  end

end
