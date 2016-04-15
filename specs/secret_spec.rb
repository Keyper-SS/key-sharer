require_relative './spec_helper'

describe 'Testing Secret resource routes' do
  before do
    Account.dataset.delete
    Secret.dataset.delete
    Sharing.dataset.delete
  end

  describe 'Creating new secret' do
    it 'HAPPY: should create a new unique account and secret' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        username: 'esalazar',
        password: '1234',
        email: 'test@example.com'
      }.to_json
      post '/api/v1/accounts/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        account_id: 1,
        title: 'Netflix Account',
        description: 'netflix account',
        share_account: 'esalazar',
        share_password: '1234'
      }.to_json
      post '/api/v1/accounts/1/secrets/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create a key with duplicate title' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        title: 'Netflix Account',
        description: 'netflix account',
        share_account: 'esalazar',
        share_password: '1234'
      }.to_json
      post '/api/v1/accounts/', req_body, req_header
      post '/api/v1/accounts/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing key' do
    it 'HAPPY: should find an existing keys' do
      new_account = Account.create(username: 'esalazar', password: '1234', email: 'test@example.com')
      new_secret = (1..3).map do |i|
          s = {
            title: "random_secret#{i}.rb",
            description: "test string#{i}",
            share_account: "asdf#{i}",
            share_password: "1234",
          }
          new_account.add_secret(s)
      end

      get "/api/v1/accounts/#{new_account.username}/secrets"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_account.id
      3.times do |i|
        _(results['keys']['owned'][i]['id']).must_equal new_secret[i].id
      end
    end

    it 'SAD: should not find non-existent accounts' do
      get "/api/v1/accounts/#{invalid_id(Account)}/secrets"
      _(last_response.status).must_equal 404
    end
  end

end
