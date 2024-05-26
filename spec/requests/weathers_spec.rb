require 'rails_helper'

RSpec.describe "Weather", type: :request do
  describe "GET /show" do
    before do
      municipalities_names = ["奥多摩町", "青梅市", "立川市", "練馬区", "新宿区", "千代田区", "品川区", "世田谷区", "八王子市", "檜原村"]   
      municipalities_names.each do |name|
        FactoryBot.create(:municipality, name: name)
      end
      get root_path
    end

    it "TOPページにアクセスできること" do
      expect(response).to have_http_status(200)
    end
  end
end
