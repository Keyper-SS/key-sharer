user1 = CreateUser.call(
  username: 'vicky',
  email: 'vicky@test.com',
  password: 'v12345678')

user2 = CreateUser.call(
  username: 'eduardo',
  email: 'eduardo@test.com',
  password: 'e12345678')

user3 = CreateUser.call(
  username: 'yiwei',
  email: 'yiwei@test.com',
  password: 'w12345678')

secret11 = CreateSecret.call(
  title: 'google account',
  description: 'google',
  username: 'vicky',
  account: 'vicky_google',
  password: 'v12345678')

secret12 = CreateSecret.call(
  title: 'netflix account',
  description: 'netflix',
  username: 'vicky',
  account: 'vicky_netflix',
  password: 'v12345678')

secret21 = CreateSecret.call(
  title: 'google account',
  description: 'google',
  username: 'eduardo',
  account: 'eduardo_google',
  password: 'e12345678')

secret22 = CreateSecret.call(
  title: 'netflix account',
  description: 'netflix',
  username: 'eduardo',
  account: 'eduardo_netflix',
  password: 'e12345678')

secret31 = CreateSecret.call(
  title: 'google account',
  description: 'google',
  username: 'yiwei',
  account: 'yiwei_google',
  password: 'w12345678')

secret32 = CreateSecret.call(
  title: 'netflix account',
  description: 'netflix',
  username: 'yiwei',
  account: 'yiwei_netflix',
  password: 'w12345678')
