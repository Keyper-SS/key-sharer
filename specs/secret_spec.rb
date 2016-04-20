require_relative './spec_helper'

describe 'Testing Secret resource routes' do
  before do
    User.dataset.delete
    Secret.dataset.delete
    Sharing.dataset.delete
  end

  describe 'Creating new secret' do
    it 'HAPPY: should create a new unique account and secret' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        username: 'esalazar',
        password_encrypted: '1234',
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
        account_encrypted: 'esalazar',
        password_encrypted: '1234'
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

  describe 'Finding existing secret' do
    it 'HAPPY: should find an existing keys' do
      new_account = User.new(email: 'esalazar@example.com')
      new_account.username = 'test'
      new_account.password_encrypted = '1234'
      new_account.save
      new_secret = (1..3).map do |i|
          secret = Secret.new(title: "random_secret#{i}.rb", description: "test string#{i}")
          secret.account_encrypted = "asdf#{i}"
          secret.password_encrypted = '1234'
          new_account.add_secret(secret)
      end

      get "/api/v1/accounts/#{new_account.username}/secrets"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_account.id
      3.times do |i|
        _(results['secrets']['owned'][i]['id']).must_equal new_secret[i].id
      end
    end

    it 'SAD: should not find non-existent accounts' do
      get "/api/v1/accounts/#{invalid_id(User)}/secrets"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Finding existing secret by given id' do
    it 'HAPPY: should find an existing keys' do
      new_account = User.new(email: 'esalazar@example.com')
      new_account.username = 'test'
      new_account.password_encrypted = '1234'
      new_account.save
      new_secret = (1..3).map do |i|
          secret = Secret.new(title: "random_secret#{i}.rb", description: "test string#{i}")
          secret.account_encrypted = "asdf#{i}"
          secret.password_encrypted = '1234'
          new_account.add_secret(secret)
      end
      3.times do |i|
        get "/api/v1/accounts/#{new_account.username}/secrets/#{new_secret[i].id}"
        _(last_response.status).must_equal 200

        results = JSON.parse(last_response.body)
        _(results['data']['type']).must_equal 'secret'
        _(results['data']['id']).must_equal new_secret[i].id
      end
    end

    it 'SAD: should not find non-existent accounts' do
      new_account = User.new(email: 'esalazar@example.com')
      new_account.username = 'test'
      new_account.password_encrypted = '1234'
      new_account.save
      get "/api/v1/accounts/#{new_account.id}/secrets/#{invalid_id(Secret)}"
      _(last_response.status).must_equal 404
    end
  end

end
