# KeyShare API [![Build Status](https://travis-ci.org/Keyper-SS/key-sharer.svg?branch=master)](https://travis-ci.org/Keyper-SS/key-sharer)
API to store key and share

## Routes

### Account Routes
- GET `api/v1/users`
  - returns a json of all user IDs
- GET `api/v1/users/:user_username`: returns a json of all information about a user
- POST `api/v1/users`: add a new user to DB
  ```ruby
  # post json example
  {

      "username": "vicky_netflix",
      "password": "12345678",
      "email": "vicky@keyper.com"
  }
  ```

### Secret Routes
- GET `api/v1/users/[user_id]/secrets/?`: return all secrets of this user
- GET `api/v1/users/[user_id]/secrets/[secret_id]?`: return detail information of a secret of a user based on given secret id
- POST `api/v1/users/[user_id]/secrets/?`: create new secret  for a certain user
  ```ruby
  # post json example
  {
      "title": "netflix",
      "description": "netflix account",
      "account": "vicky_netflix",
      "password": "12345678"
  }
  ```

## Install

Install this API by cloning the *relevant branch* and installing required gems:
```
$ bundle install
```

## Execute

Run this API by using:

```
$ rackup
```
