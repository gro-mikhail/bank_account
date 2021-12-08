require 'rails_helper'

describe 'Reports', type: :request do
  before do
    FactoryBot.create(:client, surname: 'Ivanov', name: 'Ivan', patronymic: 'Ivanovich', identification_number: '1111111B111PE1')
    FactoryBot.create(:client, surname: 'Sych', name: 'Ihar', patronymic: 'Johnovich', identification_number: '0000000B000PE0')
    FactoryBot.create(:transaction, amount: 100, currency: 'USD', transaction_type: 'UP', client_id: 1, created_at: Date.today - 5)
    FactoryBot.create(:transaction, amount: 150, currency: 'USD', transaction_type: 'UP', client_id: 1, created_at: Date.today - 4)
    FactoryBot.create(:transaction, amount: 1000, currency: 'USD', transaction_type: 'UP', client_id: 1, created_at: Date.today - 2)
    FactoryBot.create(:transaction, amount: 70, currency: 'USD', transaction_type: 'DOWN', transfer: true, client_id: 1, created_at: Date.today - 3)
    FactoryBot.create(:transaction, amount: 7000, currency: 'RUB', transaction_type: 'DOWN', transfer: true, client_id: 1, created_at: Date.today - 3)
    FactoryBot.create(:transaction, amount: 17_000, currency: 'RUB', transaction_type: 'UP', client_id: 1, created_at: Date.today - 3)
    FactoryBot.create(:transaction, amount: 100_000, currency: 'RUB', transaction_type: 'UP', client_id: 2, created_at: Date.today - 2)
  end

  it 'replenishment amount report without specifying the client' do
    post reports_replenishment_amount_by_currency_index_path, params: { start_date: Date.today - 6,
                                                                        final_date: Date.today }

    result = JSON.parse(response.body, symbolize_names: true)

    sum_usd = result.find { |r| r[:currency].eql?('USD') }[:sum]
    sum_rub = result.find { |r| r[:currency].eql?('RUB') }[:sum]
    expect(response).to have_http_status(200)
    expect(sum_usd).to eq(1250)
    expect(sum_rub).to eq(117_000)
  end

  it 'replenishment amount report with the client\'s indication' do
    post reports_replenishment_amount_by_currency_index_path, params: { start_date: Date.today - 6,
                                                                        final_date: Date.today,
                                                                        clients: ['1111111B111PE1'] }
    result = JSON.parse(response.body, symbolize_names: true)

    sum_usd = result.find { |r| r[:currency].eql?('USD') && r[:identification_number].eql?('1111111B111PE1') }[:sum]
    sum_rub = result.find { |r| r[:currency].eql?('RUB') && r[:identification_number].eql?('1111111B111PE1') }[:sum]
    expect(response).to have_http_status(200)
    expect(sum_usd).to eq(1250)
    expect(sum_rub).to eq(17_000)
  end

  it 'replenishment amount report no results' do
    post reports_replenishment_amount_by_currency_index_path, params: { start_date: Date.today - 1,
                                                                        final_date: Date.today + 1 }

    result = JSON.parse(response.body, symbolize_names: true)

    expect(response).to have_http_status(200)
    expect(result).to match_array([])
  end
end
