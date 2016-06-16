class CreateSeedData
  def self.call
    user_vicky = create_new_user(
      username: 'vicky',
      email: 'vicky@test.com',
      password: 'v12345678')

    user_eduardo = create_new_user(
      username: 'eduardo',
      email: 'eduardo@test.com',
      password: 'e12345678')

    user_yiwei = create_new_user(
      username: 'yiwei',
      email: 'yiwei@test.com',
      password: 'w12345678')

    vicky_google = create_new_secret(
      title: 'google account',
      description: 'google',
      owner_id: 1,
      account: 'vicky_google',
      password: 'v12345678')

    vicky_netflix = create_new_secret(
      title: 'netflix account',
      description: 'netflix',
      owner_id: 1,
      account: 'vicky_netflix',
      password: 'v12345678')

    vicky_card = create_new_secret(
      title: 'vicky visa card',
      description: 'vicky visa card, only card owner_id',
      owner_id: 1,
      account: 'vicky_card_111',
      password: nil)

    eduardo_google = create_new_secret(
      title: 'google account',
      description: 'google',
      owner_id: 2,
      account: 'eduardo_google',
      password: 'e12345678')

    eduardo_netflix = create_new_secret(
      title: 'netflix account',
      description: 'netflix',
      owner_id: 2,
      account: 'eduardo_netflix',
      password: 'e12345678')

    eduardo_card = create_new_secret(
      title: 'eduardo visa card',
      description: 'eduardo visa card, only card owner_id',
      owner_id: 2,
      account: 'eduardo_card_2222',
      password: nil)

    yiwei_google = create_new_secret(
      title: 'google account',
      description: 'google',
      owner_id: 3,
      account: 'yiwei_google',
      password: 'w12345678')

    yiwei_netflix = create_new_secret(
      title: 'netflix account',
      description: 'netflix',
      owner_id: 3,
      account: 'yiwei_netflix',
      password: 'w12345678')

    yiwei_card = create_new_secret(
      title: 'yiwei visa card',
      description: 'yiwei visa card, only card owner_id',
      owner_id: 3,
      account: 'yiwei_card_3333',
      password: nil)

    share_ve_netflix = create_new_sharing(
      sharer_id: user_vicky.id,
      receiver_id: user_eduardo.id,
      secret_id: vicky_netflix.id
    )
    share_ew_netflix = create_new_sharing(
      sharer_id: user_eduardo.id,
      receiver_id: user_yiwei.id,
      secret_id: eduardo_netflix.id
    )
    share_wv_netflix = create_new_sharing(
      sharer_id: user_yiwei.id,
      receiver_id: user_vicky.id,
      secret_id: yiwei_netflix.id
    )

    share_vw_card = create_new_sharing(
      sharer_id: user_vicky.id,
      receiver_id: user_yiwei.id,
      secret_id: vicky_card.id
    )
    share_we_card = create_new_sharing(
      sharer_id: user_yiwei.id,
      receiver_id: user_eduardo.id,
      secret_id: yiwei_card.id
    )
    share_ev_card = create_new_sharing(
      sharer_id: user_eduardo.id,
      receiver_id: user_vicky.id,
      secret_id: eduardo_card.id
    )
  end

  private_class_method

  def self.create_new_secret(title:, description:, owner_id:, account:, password:)
    secret = Secret.new(
      title: title,
      description: description)
    user = BaseUser[owner_id]
    secret.account = account
    secret.password = password
    user.add_owned_secret(secret)
  end

  def self.create_new_user(username:, email:, password:)
    user = User.new(username: username,email: email)
    user.password = password
    user.save
  end

  def self.create_new_sharing(sharer_id:, receiver_id:, secret_id:)
    sharing = Sharing.new(
      sharer_id: sharer_id,
      receiver_id: receiver_id,
      secret_id: secret_id
    )
    sharing.save
  end
end
