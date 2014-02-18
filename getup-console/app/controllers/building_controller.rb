class BuildingController < ConsoleController

  def show
    user_default_domain
    @application = @domain.find_application params[:application_id]
    redirect_to new_application_building_path(@application) unless @application.builds?
  end

  def new
    user_default_domain
    @application = @domain.find_application params[:application_id]
    @jenkins_server = if @application.building_app
        @domain.find_application(@application.building_app) if @application.building_app
      else
        Application.new({:name => 'jenkins'}, false)
      end
    @cartridge_type = CartridgeType.cached.all.find{ |c| c.tags.include? :ci_builder }
    @cartridge = Cartridge.new :name => @cartridge_type.name
  end

  def create
    @domain = Domain.find :one, :as => current_user
    @application = @domain.find_application(params[:application_id])
    @jenkins_server = @domain.find_application(@application.building_app) if @application.building_app
    @cartridge_type = CartridgeType.cached.all.find{ |c| c.tags.include? :ci_builder }
    @cartridge = Cartridge.new :name => @cartridge_type.name

    unless @jenkins_server
      framework = CartridgeType.cached.all.find{ |c| c.tags.include? :ci }
      @jenkins_server = Application.new(
        :name => params[:application][:name],
        :cartridge => framework.name,
        :domain => @domain,
        :as => current_user)

      if @jenkins_server.save
        message = @jenkins_server.remote_results
      else
        render :new and return
      end
    end

    @cartridge.application = @application

    success, attempts = @cartridge.save, 1
    while (!success && @cartridge.has_exit_code?(157, :on => :cartridge) && attempts < 2)
      logger.debug "  Jenkins server could not be contacted, sleep and then retry\n    #{@cartridge.errors.inspect}"
      sleep(10)
      success = @cartridge.save
      attempts += 1
    end

    if success
      redirect_to application_building_path(@application), :flash => {:info_pre => @cartridge.remote_results.concat(message || []).concat(['Your application is now building with Jenkins.'])}
    else
      if @cartridge.has_exit_code?(157, :on => :cartridge)
        message = I18n.t(:jenkin_wait_dns)
      else
        @cartridge.errors.full_messages.each{ |m| @jenkins_server.errors.add(:base, m) }
      end
      flash.now[:info_pre] = message
      render :new
    end
  end

  def delete
    user_default_domain
    @application = @domain.find_application params[:application_id]
    redirect_to new_application_building_path(@application) unless @application.builds?
  end

  def destroy
    @domain = Domain.find :one, :as => current_user
    @application = @domain.find_application params[:application_id]
    if @application.destroy_build_cartridge
      redirect_to application_path(@application), :flash => {:success => I18n.t(:jenkins_app_not_building, app: @application.name)}
    else
      render :delete
    end
  end
end
