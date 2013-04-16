module Console::AuthenticationHelper

  def generate_token (password)
    "%02d" % password.length + password.reverse + Console.config.authentication_session_key + Time.now.to_i.to_s
  end

  def decode_token (token)
  	{
  	  :expired => expired?(token),
  	  :password => get_password(token)
  	}
  end

  private
  	def get_password (token)
  	  length = token[0..1].to_i + 1
  	  token[2..length].reverse
  	end

  	def expired? (token)
  	  expire = token[-10..-1]
  	  Time.now.to_i - expire.to_i > Console.config.authentication_session_expire.to_i
  	end
end
