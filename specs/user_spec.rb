require_relative './spec_helper'

describe 'Testing Account resource routes' do
  before do
    User.dataset.delete
    Secret.dataset.delete
  end

  describe 'Creating new accounts' do
    it 'HAPPY: should create a new unique account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        username: 'vicky',
        password_encrypted: '1234',
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
        password_encrypted: '1234',
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
      new_account = User.new(email: 'yiwei@keyper.com')
      new_account.username = 'yiwei'
      new_account.password_encrypted = '1234'
      new_account.save
      new_secret = (1..3).map do |i|
          secret = Secret.new(title: "random_secret#{i}.rb", description: "test string#{i}")
          secret.account_encrypted = "asdf#{i}"
          secret.password_encrypted = '1234'
          new_account.add_secret(secret)
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
      get "/api/v1/accounts/#{invalid_id(User)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing accounts' do
    it 'HAPPY: should find list of existing accounts' do
      (1..5).each do |i| 
        user = User.new(email: "asdf#{i}@keyper.com") 
        user.username = "asdf#{i}"
        user.password_encrypted = '1234'
        user.save
      end
      result = get '/api/v1/accounts'
      projs = JSON.parse(result.body)
      _(projs['data'].count).must_equal 5
    end
  end
end
