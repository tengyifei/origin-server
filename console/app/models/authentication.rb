class Authentication

  def initialize(login, password)
    @login = login
    generate_token password
  end

  def expired?
    secret = Digest::SHA1.hexdigest(Console.config.authentication_session_key)
    token = ActiveSupport::MessageEncryptor.new(secret).decrypt_and_verify(@token)

    created_at = token[-10..-1]
    (Time.now.to_i - created_at.to_i > Console.config.authentication_session_expire.to_i)
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

  def login
    @login
  end
end