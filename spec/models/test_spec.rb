# spec/database_connection_spec.rb

require 'rails_helper'

RSpec.describe 'Database connection', type: :model do
  it 'connects to the test database' do
    ActiveRecord::Base.establish_connection(:test)
    expect(ActiveRecord::Base.connection_pool.with_connection(&:active?)).to eq(true)
  end
end
