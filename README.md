# KeyShare API [![Build Status](https://travis-ci.org/Keyper-SS/key-sharer.svg?branch=master)](https://travis-ci.org/Keyper-SS/key-sharer)
API to store key and share

## Routes

### Account Routes
- GET `api/v1/accounts`: returns a json of all account IDs
- GET `api/v1/accounts/:account_username`: returns a json of all information about a user
- POST `api/v1/accounts`: add a new user to DB

### Secret Routes
- GET `api/v1/accounts/[account_id]/secrets/?`: return all secrets of this account
- GET `api/v1/accounts/[account_id]/secrets/[secret_id]?`: return detail information of a secret of a account based on given secret id
- GET `api/v1/accounts/[account_id]/secrets/[secret_title]?` (optional): return detail information of a secret of a account  based on given secret title
- POST `api/v1/accounts/[account_id]/secrets/?`: create new secret  for a certain account

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
