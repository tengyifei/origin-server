class ApplicationController < ActionController::Base
  include Console::Rescue

  protect_from_forgery

  protected
    def account_settings_redirect
      settings_path
    end
end
