module Console::GetupAdminHelper
  # 
  # 
  def getup_admin_post (path, params={})

    path = format_path path

    params[:csrfmiddlewaretoken] = 'getup'

    uri = URI.parse "https://broker-dev.getupcloud.com:443/getup" + path[:address]

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new uri.request_uri 
    request["Cookie"] = "csrftoken=getup"
    request['X-Remote-User'] = path[:user] if path[:user]

    request.set_form_data(params)

    response = http.request request
    response_code = response.code.to_i

    response
  end

  def getup_admin_get (path, params={})

    path = format_path path

    uri = URI.parse "https://broker-dev.getupcloud.com:443/getup" + path[:address]

    http = Net::HTTP.new uri.host, uri.port
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new uri.request_uri, headers
    request['X-Remote-User'] = path[:user] if path[:user]

    request.set_form_data(params)

    response = http.request request
    response_code = response.code.to_i

    response
  end

  private
    def format_path path
      if path[0] != '/'
        pipe_position = path.index '/'
        {:user => (path.slice 0, pipe_position), :address => (path.slice pipe_position..-1)}
      else
        {:address => path}
      end
    end
end
