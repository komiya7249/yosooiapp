require 'rails_helper'

RSpec.describe "気象情報", type: :system do
  describe 'TOPページ', js: true do

    before do
      @week = %w[(日) (月) (火) (水) (木) (金) (土)]
      municipalities_names = ["奥多摩町", "青梅市", "立川市", "練馬区", "新宿区", "千代田区", "品川区", "世田谷区", "八王子市", "檜原村"]   
      municipalities_names.each do |name|
        FactoryBot.create(:municipality, name: name)
      end
      visit root_path
    end
  
    let(:municipality) { Municipality.first }
    let(:tomorrow) { Time.zone.today + 1 }
    let(:day_before_yesterday) { Time.zone.today - 2 }
    let(:weathers) { municipality.weathers }
    let(:main_day) { tomorrow.strftime('%m月%d日') + "#{@week[tomorrow.wday]}" }
    let(:sub_day) { day_before_yesterday.strftime('%m月%d日') + "#{@week[day_before_yesterday.wday]}" }
    let(:main_weather) { weathers.find_by(time: tomorrow) }
    let(:sub_weather) { weathers.find_by(time: day_before_yesterday) }
  

    it 'weathermapにて曜日の切り替え・市区町村の詳細ページへ移動できること' do
      find('[data-tab="2"]').click
      expect(page).to have_selector('li.tab_menu-item.is-active[data-tab="2"]')

      find('.okutama').click
      okutama = Municipality.find_by(name: '奥多摩町')
      expect(current_path).to eq weather_path(okutama.id)
    end

    it '地域一覧から詳細ページへ移動してヘッダーロゴからTOPページへ戻ることができること' do
      click_link municipality.name
      expect(current_path).to eq weather_path(municipality.id)

      click_link 'yosooi.tokyo'
      expect(current_path).to eq root_path
    end
    
    it '「過去の天気と比較」機能が使用できること' do
      select municipality.name, from: 'municipalitie_name'
      select main_day, from: 'main_day'
      select sub_day, from: 'sub_day'
      click_on '比較する'

      within('.comparison_main_box') do
        expect(page).to have_text(municipality.name)
        expect(page).to have_text(main_day)
        expect(page).to have_text(main_weather.temperature_max)
        expect(page).to have_text(main_weather.temperature_min)
        expect(page).to have_text(main_weather.temperature_min)
      end
      within('.comparison_sub_box') do
        expect(page).to have_text(municipality.name)
        expect(page).to have_text(sub_day)
        expect(page).to have_text(sub_weather.temperature_max)
        expect(page).to have_text(sub_weather.temperature_min)
        expect(page).to have_text(sub_weather.temperature_min)
      end

    end 
  end
end
