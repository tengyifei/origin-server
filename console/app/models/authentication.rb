class Authentication < ActiveResource::Base

  schema do
    string :id, :login, :password
  end

  def initialize(login, password)
    @login = login
    generate_token password
  end

  def expired?
    (Time.now.to_i - created_at > Console.config.authentication_session_expire.to_i)
  end

  def expires_in
    Console.config.authentication_session_expire.to_i - (Time.now.to_i - created_at)
  end

  def update_expires
    generate_token password
  end

  def generate_token(password)
    secret = Digest::SHA1.hexdigest(Console.config.authentication_session_key)
    token_text = "%02d" % password.length + password.reverse + Console.config.authentication_session_key + Time.now.to_i.to_s

    @token = ActiveSupport::MessageEncryptor.new(secret).encrypt_and_sign(token_text)
  end

  def password
    secret = Digest::SHA1.hexdigest(Console.config.authentication_session_key)
    token = ActiveSupport::MessageEncryptor.new(secret).decrypt_and_verify(@token)
    
    length = token[0..1].to_i + 1
    token[2..length].reverse
  end

  def change_password(password, new_password)
    uri = URI.parse "https://broker.getupcloud.com:443/getup/accounts/password_change/"

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new uri.request_uri 
    request["Cookie"] = "csrftoken=getup"
    request.set_form_data({ :email => @login, :old_password => password, :new_password => new_password, :csrfmiddlewaretoken => 'getup' })

    response = http.request request
    response_code = response.code.to_i

    generate_token new_password if response_code >= 200 and response_code < 400
    
    response
  end

  def self.reset_password(email)
    uri = URI.parse "https://broker.getupcloud.com:443/getup/accounts/password_reset/"

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new uri.request_uri 
    request["Cookie"] = "csrftoken=getup"
    request.set_form_data({ :email => email, :csrfmiddlewaretoken => 'getup' })

    response = http.request request

    response
  end

  def self.update_password(password, token)
    uri = URI.parse "http://broker.getupcloud.com:443/getup/accounts/password_reset/" + token + "/"

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new uri.request_uri 
    request["Cookie"] = "csrftoken=getup"
    request.set_form_data({ :new_password => password, :csrfmiddlewaretoken => 'getup' })

    response = http.request request
    response_code = response.code.to_i

    response_code >= 200 and response_code < 400
  end

  def login
    @login
  end

  private
    def created_at
      secret = Digest::SHA1.hexdigest(Console.config.authentication_session_key)
      token = ActiveSupport::MessageEncryptor.new(secret).decrypt_and_verify(@token)

      token[-10..-1].to_i
    end
end