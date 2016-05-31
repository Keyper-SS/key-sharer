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

  describe 'Testing unit level properties of users' do
    before do
      @original_password = 'mypassword'
      @user = CreateUser.call(
        username: 'soumya.ray',
        email: 'sray@nthu.edu.tw',
        password: @original_password)
    end

    it 'HAPPY: should hash the password' do
      _(@user.password_hash).wont_equal @original_password
    end

    it 'HAPPY: should re-salt the password' do
      hashed = @user.password_hash
      @user.password = @original_password
      @user.save
      _(@user.password_hash).wont_equal hashed
    end
  end

  describe 'Finding existing users' do
    before do
      @new_user = CreateUser.call(
        username: 'vicky',
        email: 'vicky@keyper.com',
        password: '1234')

      @user, @auth_token =
        AuthenticateUser.call(username: 'vicky', password: '1234')
    end

    it 'HAPPY: should find an existing user' do
      get "/api/v1/users/#{@user.id}", nil,
          { "HTTP_AUTHORIZATION" => "Bearer #{@auth_token}" }

      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal @new_user.id
    end

    it 'SAD: should not find non-existent users' do
      get "/api/v1/users/#{invalid_id(User)}"
      _(last_response.status).must_equal 401
    end

    it 'SAD: should not return user without authorization' do
      get "/api/v1/users/#{@new_user.id}"
      _(last_response.status).must_equal 401
    end
  end

  describe 'Authenticating an user' do
    def login_with(username:, password:)
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { username: username,
                   password: password }.to_json
      post '/api/v1/users/authenticate', req_body, req_header
    end

    before do
      @user = CreateUser.call(
        username: 'vicky',
        password: '1234',
        email: 'vicky@keyper.com')
    end

    it 'HAPPY: should be able to authenticate a real user' do
       login_with(username: 'vicky', password: '1234')
       _(last_response.status).must_equal 200
       response = JSON.parse(last_response.body)
       _(response['user']).wont_equal nil
       _(response['auth_token']).wont_equal nil
     end


    it 'SAD: should not authenticate an user with wrong password' do
      login_with(username: 'vicky', password: '0000')
      _(last_response.status).must_equal 401
    end

    it 'SAD: should not authenticate an user with an invalid username' do
      login_with(username: 'randomuser', password: '1234')
      _(last_response.status).must_equal 401
    end

    it 'BAD: should not authenticate an user without password' do
      login_with(username: 'vicky', password: '')
      _(last_response.status).must_equal 401
    end
  end
end
