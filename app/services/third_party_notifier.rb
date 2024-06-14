class ThirdPartyNotifier
  require 'rest-client'

  def initialize(event, user)
    @event = event
    @user = user
    @endpoint_urls = ENV['third_party_urls']
    @secret_key = ENV['secret_key']
  end

  def notify
    begin
      urls = @endpoint_urls
      timestamp = Time.now.to_i
      request_payload = { event: @event, user: @user }.to_json

      signature = OpenSSL::HMAC.hexdigest('SHA256', @secret_key, request_payload)

      headers = {
        content_type: :json,
        accept: :json,
        'X-Webhook-Timestamp' => timestamp.to_s,
        'X-Webhook-Signature' => signature
      }
      
      urls.each do |url|
        RestClient::Request.execute(method: :post, url: url, payload: request_payload, headers: headers)
      end
    rescue Exception => e
      raise e.message
    end
  end

end