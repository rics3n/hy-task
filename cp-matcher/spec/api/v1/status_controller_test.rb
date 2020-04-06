require "rails_helper"

RSpec.describe "status api", :type => :request do
  it "should return status code 200" do
    get "/api/v1/status"
    expect(response.status).to eq 200
  end
end