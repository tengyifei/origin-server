class Profile < ActiveResource::Base

  schema do
    string :id, :email, :password, :gear, :news, :terms
  end

  def initialize(login, password)
    @login = login
    generate_token password
  end

  def save(password, new_password)
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
end