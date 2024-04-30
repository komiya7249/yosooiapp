require 'rails_helper'

RSpec.describe "Homes", type: :request do
  describe "GET /index" do
    before do
      get root_path
    end

    it "TOPページにアクセスできること" do
      expect(response).to have_http_status(200)
    end
  end
end
