module Console::GetupAdminHelper

  class GetupResponse
    def initialize(response)
      @code = response.code.to_i
      @body = response.body
      @message = response.message
      @content = JSON.parse response.body, :symbolize_names => true rescue nil
    end

    def code
      @code
    end

    def body
      @body
    end

    def message
      @message
    end 

    def content
      @content
    end
  end

  # 
  # 
  def getup_admin_post (path, params={})

    path = format_path path

    params[:csrfmiddlewaretoken] = 'getup'

    uri = URI.parse get_local_broker_url + "/getup" + path[:address]

    http = Net::HTTP.new uri.host, uri.port
    #http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Post.new uri.request_uri 
    request["Cookie"] = "csrftoken=getup"
    request['X-Remote-User'] = path[:user] if path[:user]

    request.set_form_data(params)

    print request.to_yaml

    response = http.request request
    response_code = response.code.to_i

    GetupResponse.new response
  end

  def getup_admin_get (path, params={})

    path = format_path path

    uri = URI.parse get_local_broker_url + "/getup" + path[:address]

    http = Net::HTTP.new uri.host, uri.port
    #http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    request = Net::HTTP::Get.new uri.request_uri, headers
    request['X-Remote-User'] = path[:user] if path[:user]

    request.set_form_data(params)

    response = http.request request
    response_code = response.code.to_i

    GetupResponse.new response
  end

  private
    def get_local_broker_url
      Console.config.api[:broker]
    end

    def format_path path
      if path[0] != '/'
        pipe_position = path.index '/'
        {:user => (path.slice 0, pipe_position), :address => (path.slice pipe_position..-1)}
      else
        {:address => path}
      end
    end
end
