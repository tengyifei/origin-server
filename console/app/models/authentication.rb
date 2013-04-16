class Authentication
  schema do
    string :login, :token
  end

  def expired?
      created_at = self.token[-10..-1]
      not (Time.now.to_i - created_at.to_i > Console.config.authentication_session_expire.to_i)
  end

  def generate_token(password)
    secret = Digest::SHA1.hexdigest(Console.config.authentication_session_key)
    token = "%02d" % password.length + password.reverse + Console.config.authentication_session_key + Time.now.to_i.to_s

    self.token = ActiveSupport::MessageEncryptor.new(secret).encrypt_and_sign(token)
  end

  def password
    length = self.token[0..1].to_i + 1
    self.token[2..length].reverse
  end
end