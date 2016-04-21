require_relative './spec_helper'

describe 'Testing User resource routes' do
  before do
    User.dataset.delete
    Secret.dataset.delete
    Sharing.dataset.delete
  end

  describe 'Creating new users' do
    it 'HAPPY: should create a new unique user' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        username: 'vicky',
        password: '1234',
        email: 'vicky@keyper.com'
      }.to_json
      post '/api/v1/users/', req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create users with duplicate names' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = {
        username: 'vicky',
        password: '1234',
        email: 'vicky@keyper.com'
      }.to_json
      post '/api/v1/users/', req_body, req_header
      post '/api/v1/users/', req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end

  describe 'Finding existing users' do
    it 'HAPPY: should find an existing user' do
      new_user = User.new(email: 'vicky@keyper.com')
      new_user.username = 'vicky'
      new_user.password = '1234'
      new_user.save

      get "/api/v1/users/#{new_user.username}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal new_user.id
    end

    it 'SAD: should not find non-existent users' do
      get "/api/v1/users/#{invalid_id(User)}"
      _(last_response.status).must_equal 404
    end
  end

  describe 'Getting an index of existing users' do
    it 'HAPPY: should find list of existing users' do
      (1..5).each do |i|
        user = User.new(email: "vicky#{i}@keyper.com")
        user.username = "vicky#{i}"
        user.password_encrypted = '1234'
        user.save
      end
      result = get '/api/v1/users'
      projs = JSON.parse(result.body)
      _(projs['data'].count).must_equal 5
    end
  end
end
