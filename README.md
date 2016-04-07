# KeyShare API
API to store key and share

## Routes

- GET `api/v1/keys`: returns a json of all keys IDs
- GET `api/v1/keys/[Key_ID].json`: returns a json of all information about a key with a given key ID
- POST `api/v1/keys`: add a key object to DB

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
