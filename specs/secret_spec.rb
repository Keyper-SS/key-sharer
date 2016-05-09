require_relative './spec_helper'

describe 'Testing Secret resource routes' do
  before do
    User.dataset.delete
    Secret.dataset.delete
    Sharing.dataset.delete
  end

  describe 'Creating new secret' do
    it 'HAPPY: should create a new unique user and secret' do
      existing_user = CreateUser.call(
        username: 'vicky',
        email: 'vicky@keyper.com',
        password: '1234')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        title: 'Netflix Account',
        description: 'netflix user',
        account: 'vicky',
        password: '1234'
      }.to_json

      post_secret_url = "/api/v1/users/#{existing_user.username}/owned_secrets/"
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
      post '/api/v1/users/vicky/owned_secrets', req_body, req_header
      post '/api/v1/users/vicky/owned_secrets', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing owned secret' do
    it 'HAPPY: should find an existing secrets' do
      new_user = CreateUser.call(
        username: 'vicky',
        email: 'vicky@keyper.com',
        password: '1234')

      new_secret = (1..3).map do |i|
        CreateSecret.call(
          title: "random_secret#{i}.rb",
          description: "test string#{i}",
          username: 'vicky',
          account: "vicky#{i}",
          password: '1234'
        )
      end

      get "/api/v1/users/#{new_user.username}/owned_secrets"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_user.id
      3.times do |i|
        _(results['owned_secrets'][i]['id']).must_equal new_secret[i].id
      end
    end

    it 'SAD: should not find non-existent users' do
      get "/api/v1/users/#{invalid_id(User)}/owned_secrets"
      _(last_response.status).must_equal 404
    end
  end
end
