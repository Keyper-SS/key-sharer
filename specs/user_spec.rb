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
      new_user = CreateUser.call(
        username: 'vicky',
        email: 'vicky@keyper.com',
        password: '1234')

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
        CreateUser.call(
          username: "vicky#{i}",
          email: "vicky#{i}@keyper.com",
          password: '1234')
      end
      result = get '/api/v1/users'
      projs = JSON.parse(result.body)
      _(projs['data'].count).must_equal 5
    end
  end

  describe 'Authenticating an account' do
    def login_with(username:, password:)
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: username,
                   password: password }.to_json
      post '/api/v1/users/authenticate', req_body, req_header
    end

    before do
      @account = CreateUser.call(
        username: 'vicky',
        password: '1234',
        email: 'vicky@keyper.com')
    end

    it 'HAPPY: should be able to authenticate a real account' do
       login_with(username: 'vicky', password: '1234')
       _(last_response.status).must_equal 200
       response = JSON.parse(last_response.body)
       _(response['user']).wont_equal nil
       _(response['auth_token']).wont_equal nil
     end


    it 'SAD: should not authenticate an account with wrong password' do
      login_with(username: 'vicky', password: '0000')
      _(last_response.status).must_equal 401
    end

    it 'SAD: should not authenticate an account with an invalid username' do
      login_with(username: 'randomuser', password: '1234')
      _(last_response.status).must_equal 401
    end

    it 'BAD: should not authenticate an account without password' do
      login_with(username: 'vicky', password: '')
      _(last_response.status).must_equal 401
    end
  end
end
