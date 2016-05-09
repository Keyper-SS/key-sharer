user_vicky = CreateUser.call(
  username: 'vicky',
  email: 'vicky@test.com',
  password: 'v12345678')

user_eduardo = CreateUser.call(
  username: 'eduardo',
  email: 'eduardo@test.com',
  password: 'e12345678')

user_yiwei = CreateUser.call(
  username: 'yiwei',
  email: 'yiwei@test.com',
  password: 'w12345678')

vicky_google = CreateSecret.call(
  title: 'google account',
  description: 'google',
  username: 'vicky',
  account: 'vicky_google',
  password: 'v12345678')

vicky_netflix = CreateSecret.call(
  title: 'netflix account',
  description: 'netflix',
  username: 'vicky',
  account: 'vicky_netflix',
  password: 'v12345678')

vicky_card = CreateSecret.call(
  title: 'vicky visa card',
  description: 'vicky visa card, only card id',
  username: 'vicky',
  account: 'vicky_card_111',
  password: nil)

eduardo_google = CreateSecret.call(
  title: 'google account',
  description: 'google',
  username: 'eduardo',
  account: 'eduardo_google',
  password: 'e12345678')

eduardo_netflix = CreateSecret.call(
  title: 'netflix account',
  description: 'netflix',
  username: 'eduardo',
  account: 'eduardo_netflix',
  password: 'e12345678')

eduardo_card = CreateSecret.call(
  title: 'eduardo visa card',
  description: 'eduardo visa card, only card id',
  username: 'eduardo',
  account: 'eduardo_card_2222',
  password: nil)

yiwei_google = CreateSecret.call(
  title: 'google account',
  description: 'google',
  username: 'yiwei',
  account: 'yiwei_google',
  password: 'w12345678')

yiwei_netflix = CreateSecret.call(
  title: 'netflix account',
  description: 'netflix',
  username: 'yiwei',
  account: 'yiwei_netflix',
  password: 'w12345678')

yiwei_card = CreateSecret.call(
  title: 'yiwei visa card',
  description: 'yiwei visa card, only card id',
  username: 'yiwei',
  account: 'yiwei_card_3333',
  password: nil)

share_ve_netflix = CreateSharing.call(
  sharer_id: user_vicky.id,
  receiver_id: user_eduardo.id,
  secret_id: vicky_netflix.id
)
share_ew_netflix = CreateSharing.call(
  sharer_id: user_eduardo.id,
  receiver_id: user_yiwei.id,
  secret_id: eduardo_netflix.id
)
share_wv_netflix = CreateSharing.call(
  sharer_id: user_yiwei.id,
  receiver_id: user_vicky.id,
  secret_id: yiwei_netflix.id
)

share_vw_card = CreateSharing.call(
  sharer_id: user_vicky.id,
  receiver_id: user_yiwei.id,
  secret_id: vicky_card.id
)
share_we_card = CreateSharing.call(
  sharer_id: user_yiwei.id,
  receiver_id: user_eduardo.id,
  secret_id: yiwei_card.id
)
share_ev_card = CreateSharing.call(
  sharer_id: user_eduardo.id,
  receiver_id: user_vicky.id,
  secret_id: eduardo_card.id
)
