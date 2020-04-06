require "rails_helper"

RSpec.describe "ocr company name finder api", :type => :request do
  let(:default_path) { '/api/v1/ocr/invoice/find_company' }

  it "should return status code 200 when company name was found" do
    params = { "images" => Rack::Test::UploadedFile.new('data/invoice_match.png', 'application/png', true) }

    post default_path, params: params
    expect(response.status).to eq 200
  end

  it "should return the company name" do
    params = { "images" => Rack::Test::UploadedFile.new('data/invoice_match.png', 'application/png', true) }

    post default_path, params: params
    parsed_body = JSON.parse(response.body)

    expect(parsed_body['company']).to eq "GOOGLE"
  end

  it "should return the company name even if not 100% match" do
    params = { "images" => Rack::Test::UploadedFile.new('data/invoice_fuzzy_match.png', 'application/png', true) }

    post default_path, params: params
    parsed_body = JSON.parse(response.body)

    expect(parsed_body['company']).to eq "MICROSOFT"
  end

  it "should return no company name when no company was found" do
    params = { "images" => Rack::Test::UploadedFile.new('data/invoice_no_match.png', 'application/png', true) }

    post default_path, params: params
    parsed_body = JSON.parse(response.body)

    expect(parsed_body['company']).to eq nil
  end


  it "should return error when format of file is not supported" do
    params = { "images" => Rack::Test::UploadedFile.new('data/invoice_wrong_format.pdf', 'application/png', true) }

    post default_path, params: params

    expect(response.status).to eq 400
  end
end


