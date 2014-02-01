class ConsoleController < Console.config.parent_controller.constantize
  include Console.config.security_controller.constantize
  include CapabilityAware
  include DomainAware
  include SshkeyAware
  include Console::CommunityAware
  include Console::UserManagerHelper


  layout 'console'

  before_filter :authenticate_user!
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || user_manager_account_lang ||  I18n.default_locale
  end

  protected
    def active_tab
      nil
    end
    helper_method :active_tab

    def to_boolean(param)
      ['1','on','true'].include?(param.to_s.downcase) if param
    end
end
