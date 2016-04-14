require_relative './spec_helper'

describe 'Testing Account resource routes' do
  before do
    Account.dataset.delete
    Secret.dataset.delete
  end

  describe 'Creating new accounts' do
    it 'HAPPY: should create a new unique account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        username: 'vicky',
        password: '1234',
        email: 'vicky@keyper.com'
      }.to_json
      post '/api/v1/accounts/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create accounts with duplicate names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        username: 'vicky',
        password: '1234',
        email: 'vicky@keyper.com'
      }.to_json
      post '/api/v1/accounts/', req_body, req_header
      post '/api/v1/accounts/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing accounts' do
    it 'HAPPY: should find an existing account' do
      new_account = Account.create(username: 'yiwei', password: '1234', email: 'yiwei@keyper.com')
      new_secret = (1..3).map do |i|
          s = {
            title: "random_secret#{i}.rb",
            description: "test string#{i}",
            share_account: "asdf#{i}",
            share_password: "1234",
          }
          new_account.add_secret(s)
      end

      get "/api/v1/accounts/#{new_account.username}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_account.id
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal new_secret[i].id
      end
    end

    it 'SAD: should not find non-existent accounts' do
      get "/api/v1/accounts/#{invalid_id(Account)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing accounts' do
    it 'HAPPY: should find list of existing accounts' do
      (1..5).each { |i| Account.create(username: "asdf#{i}", password: '1234', email: "asdf#{i}@keyper.com") }
      result = get '/api/v1/accounts'
      projs = JSON.parse(result.body)
      _(projs['data'].count).must_equal 5
    end
  end
end
