class MainController < ApplicationController
  def index
  end

  def show
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
      callback_url: "localhost:3000/main/callback",
      description: "Learning Loop T-Shirt"
    }.to_json

    bill = HTTParty.post(url_bill.to_str, body: body, basic_auth: basic_auth, headers: headers)

    if bill.code == 200
      redirect_to bill.parsed_response["url"], allow_other_host: true
    else
      render :file => "#{Rails.root}/public/500.html", layout: false, status: :internal_server_error
    end
  end

  def callback
  end
end
