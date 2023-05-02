class MainController < ApplicationController
  skip_before_action :verify_authenticity_token

  def index
  end

  def create
    url_bill = 'https://www.billplz-sandbox.com/api/v3/bills'
    headers = { 'Content-Type' => 'application/json', 'Accept' => 'application/json' }
    basic_auth = { username: Rails.application.credentials.billplz_key }
    body =  {
      collection_id: "re4mubdd",
      email: "jdoe@email.com",
      name: "John Doe",
      amount: "2999",
      callback_url: "https://161f-219-92-22-134.ngrok-free.app/main/callback",
      redirect_url: "https://161f-219-92-22-134.ngrok-free.app/main/result",
      description: "Learning Loop T-Shirt"
    }

    x_signature_key = Rails.application.credentials.x_signature
    data = ""
    body.keys.sort.each do |b|
      data << "#{b}#{body[b]}|"
    end
    data = data.chop
    digest = OpenSSL::Digest.new('sha256')
    x_signature = OpenSSL::HMAC.hexdigest(digest, x_signature_key, data)
    body[:x_signature] = x_signature

    bill = HTTParty.post(url_bill.to_str, body: body.to_json, basic_auth: basic_auth, headers: headers)

    if bill.code == 200
      redirect_to bill.parsed_response["url"], allow_other_host: true
    else
      render :file => "#{Rails.root}/public/500.html", layout: false, status: :internal_server_error
    end
  end

  def result
    @result = JSON.pretty_generate(JSON.parse(params[:billplz].to_json))
  end

  def callback
  end
end
