# KeyShare API [![Build Status](https://travis-ci.org/Keyper-SS/key-sharer.svg?branch=master)](https://travis-ci.org/Keyper-SS/key-sharer)
API to store key and share

## Routes
### User Routes Overview
- POST `api/v1/users/authenticate`
  - authenticate this user
  - take json info, including username and password

- GET `api/v1/users`
  - returns a json of all user IDs
- GET `api/v1/users/[user_id]`:
  - returns a json of all information about a user
- POST `api/v1/users`:
  - add a new user to DB

### Secret Routes Overview
- GET `api/v1/users/[user_id]/owned_secrets`:
  -  return secrets of this user have **owned**

- GET `api/v1/users/[user_id]/shared_secrets`:
  - return secrets of this user have **shared**

- GET `api/v1/users/[user_id]/received_secrets`:
  - return secrets of this user have **received**

- POST `api/v1/users/[user_id]/owned_secrets`:
  - create new secret for a certain user

### Sharing Routes Overview
- POST `/api/v1/users/[sharer_id]/owned_secrets/[secret_id]/share`
  - to share a secret to other user
  - take json info, including receiver email


## API Example
This example is demo with the result after you use `rake db:seed` or `rake db:reseed`.

To see what have been stored in the db please look at `db/seeds/user_secret_sharing.rb`.

#### Users

**POST api/v1/users/authenticate**
```
# post json example
{
    "username": "vicky",
    "password": "v12345678"
}
```
will return
```
{
  "user": {
    "type": "user",
    "id": 1,
    "attributes": {
      "username": "vicky",
      "email": "vicky@test.com"
    }
  },
  "auth_token": "eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIiwiZXhwIjoxNDY1NDg5NjQ5fQ..7G-uVnweBLtSs7cB.uSC6hxNRYd9X1qVwLUWrNcLL__QOOHkZLRZfmuBYJaVFaSuNod5ZVfo1iWv423SUsDeCU572K8b2Do-zU6q6qKd5H4m4tMJsu9mDvXxU_aB-.AqwEFOycz2ZICkG-Y2Xfag"
}
```

**GET api/v1/users/1**

get user info

```
{
  "data": {
    "type": "user",
    "id": 1,
    "attributes": {
      "username": "vicky",
      "email": "vicky@test.com"
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

create new user

```ruby
# post json example
{

    "username": "joe",
    "password": "12345678",
    "email": "joe@keyper.com"
}
```



#### Secrets

**GET api/v1/users/1/owned_secrets**

get owned secret of a user

```
{
  "data": [
    {
      "secret_id": 1,
      "data": {
        "title": "google account",
        "description": "google",
        "account": "vicky_google",
        "password": "v12345678"
      }
    },
    {
      "secret_id": 2,
      "data": {
        "title": "netflix account",
        "description": "netflix",
        "account": "vicky_netflix",
        "password": "v12345678"
      }
    },
    {
      "secret_id": 3,
      "data": {
        "title": "vicky visa card",
        "description": "vicky visa card, only card id",
        "account": "vicky_card_111",
        "password": null
      }
    }
  ]
}
```

**GET api/v1/users/1/shared_secrets**

get secrets shared by this user

```
{
  "data": [
    {
      "secret_id": 2,
      "sharer_username": "eduardo",
      "sharer_email": "eduardo@test.com",
      "data": {
        "title": "netflix account",
        "description": "netflix",
        "account": "vicky_netflix",
        "password": "v12345678"
      }
    },
    {
      "secret_id": 3,
      "sharer_username": "yiwei",
      "sharer_email": "yiwei@test.com",
      "data": {
        "title": "vicky visa card",
        "description": "vicky visa card, only card id",
        "account": "vicky_card_111",
        "password": null
      }
    }
  ]
}
```

**GET api/v1/users/1/received_secrets**

get secrets received by this user

```
{
  "data": [
    {
      "secret_id": 8,
      "sharer_username": "yiwei",
      "sharer_email": "yiwei@test.com",
      "data": {
        "title": "netflix account",
        "description": "netflix",
        "account": "yiwei_netflix",
        "password": "w12345678"
      }
    },
    {
      "secret_id": 6,
      "sharer_username": "eduardo",
      "sharer_email": "eduardo@test.com",
      "data": {
        "title": "eduardo visa card",
        "description": "eduardo visa card, only card id",
        "account": "eduardo_card_2222",
        "password": null
      }
    }
  ]
}
```

**POST api/v1/users/1/owned_secrets**

create owned secret of this user

```ruby
# post json example
{
    "title": "netflix",
    "description": "netflix account",
    "account": "vicky_netflix",
    "password": "12345678"
}
```

#### Sharing
**POST `/api/v1/users/[sharer_id]/owned_secrets/[secret_id]/share**

share secret to other

```
# post json example
{
    "receiver_email": "eduardo@test.com"
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
