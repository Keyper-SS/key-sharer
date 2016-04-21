require_relative './spec_helper'

describe 'Testing Secret resource routes' do
  before do
    User.dataset.delete
    Secret.dataset.delete
    Sharing.dataset.delete
  end

  describe 'Creating new secret' do
    it 'HAPPY: should create a new unique user and secret' do
      existing_user = User.new(username: 'vicky',
                               email: 'vicky@keyper.com')
      existing_user.password = '1234'
      existing_user.save

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        title: 'Netflix Account',
        description: 'netflix user',
        account: 'vicky',
        password: '1234'
      }.to_json

      post_secret_url = "/api/v1/users/#{existing_user.username}/secrets/"
      post post_secret_url, req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create a secret with duplicate title' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        title: 'Netflix Account',
        description: 'netflix user',
        account: 'vicky',
        password: '1234'
      }.to_json
      post '/api/v1/users/vicky/secrets', req_body, req_header
      post '/api/v1/users/vicky/secrets', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing secret' do
    it 'HAPPY: should find an existing keys' do
      new_user = User.new(username: 'vicky',
                               email: 'vicky@keyper.com')
      new_user.password = '1234'
      new_user.save

      new_secret = (1..3).map do |i|
        secret = Secret.new(title: "random_secret#{i}.rb",
                            description: "test string#{i}")
        secret.account = "vicky#{i}"
        secret.password = '1234'
        new_user.add_secret(secret)
      end

      get "/api/v1/users/#{new_user.username}/secrets"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_user.id
      3.times do |i|
        _(results['secrets']['owned'][i]['id']).must_equal new_secret[i].id
      end
    end

    it 'SAD: should not find non-existent users' do
      get "/api/v1/users/#{invalid_id(User)}/secrets"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Finding existing secret by given id' do
    it 'HAPPY: should find an existing secrets' do
      new_user = User.new(username: 'vicky',
                          email: 'vicky@keyper.com')
      new_user.password = '1234'
      new_user.save

      new_secret = (1..3).map do |i|
        secret = Secret.new(title: "random_secret#{i}.rb",
                            description: "test string#{i}")
        secret.account = "asdf#{i}"
        secret.password = '1234'
        new_user.add_secret(secret)
      end

      3.times do |i|
        get "/api/v1/users/#{new_user.username}/secrets/#{new_secret[i].id}"
        _(last_response.status).must_equal 200

        results = JSON.parse(last_response.body)
        _(results['data']['type']).must_equal 'secret'
        _(results['data']['id']).must_equal new_secret[i].id
      end
    end

    it 'SAD: should not find non-existent secrets' do
      new_user = User.new(username: 'vicky',
                          email: 'vicky@keyper.com')
      new_user.password = '1234'
      new_user.save

      get "/api/v1/users/#{new_user.id}/secrets/#{invalid_id(Secret)}"
      _(last_response.status).must_equal 404
    end
  end
end
