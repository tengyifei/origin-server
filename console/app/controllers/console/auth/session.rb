#
# The simplest possible security strategy - this controller mixin
# will challenge the user with BASIC authentication, pass that
# information to the broker, and then cache the ticket and the user
# identifier in the session until the ticket expires.
#
module Console::Auth::Session
  extend ActiveSupport::Concern
  #include Console::AuthenticationHelper

  class SessionUser < RestApi::Credentials
    extend ActiveModel::Naming
    include ActiveModel::Conversion

    def initialize(username, password)
      @username = username
      @password = password
      @headers = { Console.config.session_user_name => username }.freeze
    end
    def login
      @username
    end
    def email_address
      nil
    end
    def to_headers
      @headers
    end
    def persisted?
      false
    end
  end

  included do
    helper_method :current_user, :user_signed_in?, :previously_signed_in?

    rescue_from ActiveResource::UnauthorizedAccess, :with => :console_access_denied
  end

  # return the current authenticated user or nil
  def current_user
    @authenticated_user
  end

  # This method should test authentication and handle if the user
  # is unauthenticated
  def authenticate_user!
    if session[:authentication_login]
      secret = Digest::SHA1.hexdigest(Console.config.authentication_session_key)

      login = session[:authentication_login]

      token = ActiveSupport::MessageEncryptor.new(secret).decrypt_and_verify(session[:authentication_token])
      user = decode_token token

      if not user[:expired]
        token = generate_token user[:password]
        secret = Digest::SHA1.hexdigest(Console.config.authentication_session_key)
        session[:authentication_token] = ActiveSupport::MessageEncryptor.new(secret).encrypt_and_sign(token)
        @authenticated_user = SessionUser.new(login, user[:password])
      else
        console_access_expired
      end
    else
      console_authentication
    end
  end

  def user_signed_in?
    not current_user.nil?
  end

  def previously_signed_in?
    cookies[:prev_login] ? true : false
  end

  protected
    def console_access_denied
      flash[:error] = "The console was unable to authenticate you with the OpenShift server."
      console_authentication
    end

    def console_access_expired
      flash[:error] = "Your session expired."
      console_authentication
    end

    def console_authentication
      redirect_to signin_path
    end
end
