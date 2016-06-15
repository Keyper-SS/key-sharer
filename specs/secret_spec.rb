require_relative './spec_helper'

describe 'Testing Secret resource routes' do
  before do
    User.dataset.delete
    Secret.dataset.delete
    Sharing.dataset.delete
  end

  describe 'Creating new secret' do
    before do
      @new_user = CreateUser.call(
        username: 'vicky',
        email: 'vicky@keyper.com',
        password: '1234'
      )

      @user, @auth_token = AuthenticateUser.call(
        username: 'vicky',
        password: '1234'
      )
    end

    it 'HAPPY: should create a new unique user and secret' do
      req_header = {
        'CONTENT_TYPE' => 'application/json',
        'HTTP_AUTHORIZATION' => "Bearer #{@auth_token}"
      }

      req_body = {
        title: 'Netflix Account',
        description: 'netflix user',
        account: 'vicky',
        password: '1234'
      }.to_json

      post_secret_url = "/api/v1/users/#{@user.id}/owned_secrets/"
      post post_secret_url, req_body, req_header

      _(last_response.status).must_equal 201
      _(JSON.parse(last_response.body)['id']).wont_be_nil
    end

    # not need this
    # it 'SAD: should not create a secret with duplicate title and account' do
    #   req_header = {
    #     'CONTENT_TYPE' => 'application/json',
    #     'HTTP_AUTHORIZATION' => "Bearer #{@auth_token}"
    #   }
    #   req_body = {
    #     title: 'Netflix Account',
    #     description: 'netflix user',
    #     account: 'vicky',
    #     password: '1234'
    #   }.to_json
    #   post "/api/v1/users/#{@user.id}/owned_secrets", req_body, req_header
    #   post "/api/v1/users/#{@user.id}/owned_secrets", req_body, req_header
    #   _(last_response.status).must_equal 400
    #   _(last_response.location).must_be_nil
    # end
  end

  describe 'Finding existing owned secret' do
    before do
      @new_user = CreateUser.call(
        username: 'vicky',
        email: 'vicky@keyper.com',
        password: '1234'
      )
      @new_secret = (1..3).map do |i|
        CreateSecret.call(
          title: "random_secret#{i}.rb",
          description: "test string#{i}",
          owner_id: @new_user.id,
          account: "vicky#{i}",
          password: '1234'
        )
      end
      @user, @auth_token =
        AuthenticateUser.call(username: 'vicky', password: '1234')
    end
    it 'HAPPY: should find an existing secrets' do
      req_header = {
        'CONTENT_TYPE' => 'application/json',
        'HTTP_AUTHORIZATION' => "Bearer #{@auth_token}"
      }
      get "/api/v1/users/#{@new_user.id}/owned_secrets", nil, req_header
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      3.times do |i|
        _(results['data'][i]['secret_id']).must_equal @new_secret[i].id
      end
    end

    it 'SAD: should not find non-existent secret' do
      req_header = {
        'CONTENT_TYPE' => 'application/json',
        'HTTP_AUTHORIZATION' => "Bearer #{@auth_token}"
      }
      get "/api/v1/users/#{@user.id}/owned_secrets/#{invalid_id(User)}", nil, req_header
      _(last_response.status).must_equal 404
    end
  end
end
