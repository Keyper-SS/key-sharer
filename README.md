# KeyShare API [![Build Status](https://travis-ci.org/Keyper-SS/key-sharer.svg?branch=master)](https://travis-ci.org/Keyper-SS/key-sharer)
API to store key and share

## Routes
### User Routes Overview
- GET `api/v1/users`
  - returns a json of all user IDs
- GET `api/v1/users/[user_username]`:
  - returns a json of all information about a user
- POST `api/v1/users`:
  - add a new user to DB
### Secret Routes Overview
- GET `api/v1/users/[user_username]/owned_secrets`:
  -  return secrets of this user have **owned**

- GET `api/v1/users/[user_username]/shared_secrets`:
  - return secrets of this user have **shared**

- GET `api/v1/users/[user_username]/received_secrets`:
  - return secrets of this user have **received**

- POST `api/v1/users/[user_username]/owned_secrets`:
  - create new secret for a certain user


### Example
This example is demo with the result after you use `rake db:seed` or `rake db:reseed`.

To see what have been stored in the db please look at `db/seeds/user_secret_sharing.rb`.

#### Users

**GET `api/v1/users`**
```
{
  "data": [
    {
      "type": "user",
      "id": 1,
      "attributes": {
        "username": "vicky"
      }
    },
    {
      "type": "user",
      "id": 2,
      "attributes": {
        "username": "eduardo"
      }
    },
    {
      "type": "user",
      "id": 3,
      "attributes": {
        "username": "yiwei"
      }
    }
  ]
}
```

**GET api/v1/users/vicky**
```
{
  "data": {
    "type": "user",
    "id": 1,
    "attributes": {
      "username": "vicky"
    }
  },
  "relationships": [
    {
      "type": "secret",
      "id": 1,
      "data": {
        "title": "google account",
        "description": "google",
        "account_encrypted": "vicky_google",
        "password_encrypted": "v12345678"
      }
    },
    {
      "type": "secret",
      "id": 2,
      "data": {
        "title": "netflix account",
        "description": "netflix",
        "account_encrypted": "vicky_netflix",
        "password_encrypted": "v12345678"
      }
    },
    {
      "type": "secret",
      "id": 3,
      "data": {
        "title": "vicky visa card",
        "description": "vicky visa card, only card id",
        "account_encrypted": "vicky_card_111",
        "password_encrypted": null
      }
    }
  ]
}
```

**POST api/v1/users**
```ruby
# post json example
{

    "username": "joe",
    "password": "12345678",
    "email": "joe@keyper.com"
}
```



#### Secret

**GET api/v1/users/vicky/owned_secrets**
```
{
  "data": {
    "type": "user",
    "id": 1,
    "attributes": {
      "username": "vicky"
    }
  },
  "owned_secrets": [
    {
      "type": "secret",
      "id": 1,
      "data": {
        "title": "google account",
        "description": "google",
        "account_encrypted": "vicky_google",
        "password_encrypted": "v12345678"
      }
    },
    {
      "type": "secret",
      "id": 2,
      "data": {
        "title": "netflix account",
        "description": "netflix",
        "account_encrypted": "vicky_netflix",
        "password_encrypted": "v12345678"
      }
    },
    {
      "type": "secret",
      "id": 3,
      "data": {
        "title": "vicky visa card",
        "description": "vicky visa card, only card id",
        "account_encrypted": "vicky_card_111",
        "password_encrypted": null
      }
    }
  ]
}
```

**GET api/v1/users/vicky/shared_secrets**
```
{
  "data": {
    "type": "user",
    "id": 1,
    "attributes": {
      "username": "vicky"
    }
  },
  "shared_secrets": [
    {
      "type": "secret",
      "id": 2,
      "data": {
        "title": "netflix account",
        "description": "netflix",
        "account_encrypted": "vicky_netflix",
        "password_encrypted": "v12345678"
      }
    },
    {
      "type": "secret",
      "id": 3,
      "data": {
        "title": "vicky visa card",
        "description": "vicky visa card, only card id",
        "account_encrypted": "vicky_card_111",
        "password_encrypted": null
      }
    }
  ]
}
```

**GET api/v1/users/vicky/received_secrets**
```
{
  "data": {
    "type": "user",
    "id": 1,
    "attributes": {
      "username": "vicky"
    }
  },
  "received_secrets": [
    {
      "type": "secret",
      "id": 8,
      "data": {
        "title": "netflix account",
        "description": "netflix",
        "account_encrypted": "yiwei_netflix",
        "password_encrypted": "w12345678"
      }
    },
    {
      "type": "secret",
      "id": 6,
      "data": {
        "title": "eduardo visa card",
        "description": "eduardo visa card, only card id",
        "account_encrypted": "eduardo_card_2222",
        "password_encrypted": null
      }
    }
  ]
}
```

**POST api/v1/users/vicky/owned_secrets**
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
