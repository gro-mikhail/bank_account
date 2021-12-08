require 'rails_helper'

describe 'Transactions', type: :request do
  before do
    FactoryBot.create(:client, surname: 'Ivanov', name: 'Ivan', patronymic: 'Ivanovich', identification_number: '1111111B111PE1', created_at: '01-01-2021')
    FactoryBot.create(:client, surname: 'Sych', name: 'Ihar', patronymic: 'Johnovich', identification_number: '0000000B000PE0')
    FactoryBot.create(:account, balance: 100.0, currency: 'USD', client_id: 1)
    FactoryBot.create(:account, balance: 5000.0, currency: 'RUB', client_id: 1)
    FactoryBot.create(:account, balance: 0.0, currency: 'BYN', client_id: 2)
  end

  it 'transfer between accounts' do
    post transactions_path, params: { amount: 20.0,
                                      currency: 'USD',
                                      sender_uid: '1111111B111PE1',
                                      recipient_uid: '0000000B000PE0' }

    expect(response).to have_http_status(200)
    expect(Account.find_by(client_id: 1, currency: 'USD').balance).to eq(80.0)
    expect(Account.find_by(client_id: 2, currency: 'USD').balance).to eq(20.00)
  end

  it 'transfer between accounts without an account with a second client' do
    post transactions_path, params: { amount: 1000.0,
                                      currency: 'RUB',
                                      sender_uid: '1111111B111PE1',
                                      recipient_uid: '0000000B000PE0' }

    expect(response).to have_http_status(200)
    expect(Account.find_by(client_id: 1, currency: 'RUB').balance).to eq(4000.0)
    expect(Account.find_by(client_id: 2, currency: 'RUB').balance).to eq(1000.0)
  end

  it 'transfer between accounts with bad sender uid' do
    post transactions_path, params: { amount: 20.0,
                                      currency: 'BYN',
                                      sender_uid: 'AAAAAAAB111PE1',
                                      recipient_uid: '0000000B000PE0' }

    expect(response).to have_http_status(400)
    expect(Account.find_by(client_id: 2, currency: 'BYN').balance).to eq(0)
  end

  it 'transfer between accounts with bad currency' do
    post transactions_path, params: { amount: 20.0,
                                      currency: 'PHTA',
                                      sender_uid: 'AAAAAAAB111PE1',
                                      recipient_uid: '0000000B000PE0' }

    expect(response).to have_http_status(400)
    expect(Account.find_by(client_id: 1, currency: 'PHTA')).to be_nil
    expect(Account.find_by(client_id: 2, currency: 'PHTA')).to be_nil
  end

  it 'transfer between accounts with bad amount' do
    post transactions_path, params: { amount: -20.0,
                                      currency: 'USD',
                                      sender_uid: 'AAAAAAAB111PE1',
                                      recipient_uid: '0000000B000PE0' }

    expect(response).to have_http_status(400)
    expect(Account.find_by(client_id: 1, currency: 'USD').balance).to eq(100.0)
    expect(Account.find_by(client_id: 2, currency: 'USD')).to be_nil
  end

  it 'transfer between accounts with with amount equal 0' do
    post transactions_path, params: { amount: 0,
                                      currency: 'USD',
                                      sender_uid: 'AAAAAAAB111PE1',
                                      recipient_uid: '0000000B000PE0' }

    expect(response).to have_http_status(400)
    expect(Account.find_by(client_id: 1, currency: 'USD').balance).to eq(100.0)
    expect(Account.find_by(client_id: 2, currency: 'USD')).to be_nil
  end

  it 'balance replenishment' do
    post transactions_path, params: { amount: 20.0, currency: 'USD', recipient_uid: '1111111B111PE1' }

    expect(response).to have_http_status(200)
    expect(Account.find_by(client_id: 1, currency: 'USD').balance).to eq(120.0)
  end

  it 'balance replenishment with bad uid' do
    post transactions_path, params: { amount: 20.0, currency: 'USD', recipient_uid: 'AAAA111B111PE1' }

    expect(response).to have_http_status(400)
    expect(Account.joins(:client).find_by(clients: { identification_number: 'AAAA111B111PE1' })).to be_nil
  end

  it 'balance replenishment with bad currency' do
    post transactions_path, params: { amount: 20.0, currency: 'PHTA', recipient_uid: '1111111B111PE1' }

    expect(response).to have_http_status(400)
    expect(Account.find_by(client_id: 1, currency: 'PHTA')).to be_nil
  end

  it 'balance replenishment with bad amount' do
    post transactions_path, params: { amount: -20.0, currency: 'USD', recipient_uid: '1111111B111PE1' }

    expect(response).to have_http_status(400)
    expect(Account.find_by(client_id: 1, currency: 'USD').balance).to eq(100.0)
  end

  it 'balance replenishment with amount equal 0' do
    post transactions_path, params: { amount: 0, currency: 'USD', recipient_uid: '1111111B111PE1' }

    expect(response).to have_http_status(400)
    expect(Account.find_by(client_id: 1, currency: 'USD').balance).to eq(100.0)
  end
end
