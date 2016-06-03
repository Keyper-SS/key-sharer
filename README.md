# KeyShare API [![Build Status](https://travis-ci.org/Keyper-SS/key-sharer.svg?branch=master)](https://travis-ci.org/Keyper-SS/key-sharer)
API to store key and share

## TOC
- [Routes](#)
	- [Authenticate Routes](#authenticate-routes)
	- [User Routes](#user-routes)
	- [Secret Routes](#secret-routes)
	- [Sharing Routes](#sharing-routes)
- [Install](#install)
- [Execute](#execute)

## Routes
### Authenticate Routes

#### Overview

| Method |            URL             |        What to do        |
| :----: | :------------------------: | :----------------------: |
|  POST  | /api/v1/users/authenticate | login and get auth token |

#### Example

**POST /api/v1/users/authenticate**
```shell
$ curl http://localhost:9292/api/v1/users/authenticate \
	-X POST \
	-H 'content-type: application/json' \
	-d '{
          "username": "vicky",
          "password": "v12345678"
        }'
```

```
$ {
    "user": {
        "type": "user",
        "id": 1,
        "attributes": {
            "username": "vicky",
            "email": "vicky@test.com"
        }
    },
    "auth_token": "eyJhbGciOiJkaXIiLCJlbmMiOiJBMjU2R0NNIiwiZXhwIjoxNDY1NTAwOTcwfQ.._z8xaYtQL2m1788r.DkQ91bhk8U7tiY5gjZNChFSRONeqGGb62I-lu_ShV4X21j0urCJ6LXI-XNXZ4WEAsYVr90mNT5U26Kdrtf3SYoz-LHQIw3fE9TpEY8T7gtEG.LSlYrZOMl5tGyDRZ3hDscA"
}
```

### User Routes
#### Overview

| Method | URL                     | What to do                               | success |
| ------ | ----------------------- | ---------------------------------------- | ------- |
| GET    | /api/v1/users/{user_id} | get all information about a certain user | 200     |
| POST   | /api/v1/users           | create a new user                        | 201     |


#### Example

**GET `/api/v1/users/{user_id}`**

```shell
curl http://localhost:9292/api/v1/users/{user_id} \
	-H 'content-type: application/json' \
	-H 'authorization: bearer {auth_token}'
```

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
    },
    {
      "type": "secret",
      "id": 10,
      "data": {
        "title": "netflix",
        "description": "netflix account",
        "account_encrypted": "vicky_netflix",
        "password_encrypted": "12345678"
      }
    }
  ]
}
```

**POST `/api/v1/users`**

```shell
curl http://localhost:9292/api/v1/users \
	-X POST \
	-H 'content-type: application/json' \
	-H 'authorization: bearer {auth_token} \
	-d '{
    "username": "vvv",
    "email": "v@test.com",
    "password": "v12345678"
}'
```



### Secret Routes

#### Overview
| Method | URL                                      | What to do                           |
| ------ | ---------------------------------------- | ------------------------------------ |
| GET    | /api/v1/users/{user_id}/owned_secrets    | owned secrets of this user           |
| GET    | /api/v1/users/{user_id}/owned_secrets/{secret_id} | a certain owned secret               |
| GET    | /api/v1/users/{user_id}/shared_secrets   | shared secrets of this user          |
| GET    | /api/v1/users/{user_id}/shared_secrets/{secret_id} | a certain shared secret              |
| GET    | /api/v1/users/{user_id}/received_secrets | received secrets of this user        |
| GET    | /api/v1/users/{user_id}/received_secrets/{secret_id} | a certain received secret            |
| POST   | /api/v1/users/{user_id}/owned_secrets    | create new secret for a certain user |



#### Example

**GET `api/v1/users/{user_id}/owned_secrets`**
```shell
$ curl http://localhost:9292/api/v1/users/1/owned_secrets \
    -H 'content-type: application/json' \
    -H 'authorization: bearer {auth_token}'
```
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


**GET `/api/v1/users/{user_id}/owned_secrets/{secret_id}`**
```shell
$ curl http://localhost:9292/api/v1/users/1/owned_secrets/1 \
	-H 'content-type: application/json' \
	-H 'authorization: bearer {auth_token}'
```

```
{
  "data": {
    "secret_id": 1,
    "data": {
      "title": "google account",
      "description": "google",
      "account": "vicky_google",
      "password": "v12345678"
    }
  }
}
```


**GET `api/v1/users/{user_id}/shared_secrets`**
```shell
$ curl http://localhost:9292/api/v1/users/1/shared_secrets \
	-H 'content-type: application/json' \
    -H 'authorization: bearer {auth_token}'
```

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


**GET `/api/v1/users/{user_id}/shared_secrets/{secret_id}`**
```shell
curl http://localhost:9292/api/v1/users/1/shared_secrets/2 \
         -H 'content-type: application/json' \
         -H 'authorization: bearer {auth_token}'
```
```
{
  "data": {
    "secret_id": 2,
    "sharer_username": "eduardo",
    "sharer_email": "eduardo@test.com",
    "data": {
      "title": "netflix account",
      "description": "netflix",
      "account": "vicky_netflix",
      "password": "v12345678"
    }
  }
}
```


**GET `api/v1/users/[user_id]/received_secrets`**
```shell
curl http://localhost:9292/api/v1/users/1/received_secrets \
         -H 'content-type: application/json' \
         -H 'authorization: bearer {auth_token}'
```
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


**GET `/api/v1/users/{user_id}/received_secrets/{secret_id}`**
```shell
curl http://localhost:9292/api/v1/users/1/received_secrets/6 \
         -H 'content-type: application/json' \
         -H 'authorization: bearer {auth_token}'
```
```
{
  "data": {
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
}
```


**POST `api/v1/users/[user_id]/owned_secrets`**
```shell
 $ curl http://localhost:9292/api/v1/users/1/owned_secrets \
 	-X POST \
	-H 'content-type: application/json' \
	-H 'authorization: bearer {auth_token}' \
	-d '{
    "title": "netflix",
    "description": "netflix account",
    "account": "vicky_netflix",
    "password": "12345678"
	}'
```


### Sharing Routes
#### Overview

| METHOD | URL                                      | What to do      |
| ------ | ---------------------------------------- | --------------- |
| POST   | /api/v1/users/{sharer_id}/owned_secrets/{secret_id}/share | to share secret |


#### Example
**POST `/api/v1/users/{sharer_id}/owned_secrets/{secret_id}/share`**

```shell
$ curl http://localhost:9292/api/v1/users/1/owned_secrets/1/share \
  -X POST \
  -H 'content-type: application/json' \
  -H 'authorization: bearer {auth_token}' \
  -d '{
  "receiver_email": "yiwei@test.com"
  }'

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
