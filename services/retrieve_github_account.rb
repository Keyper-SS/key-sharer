require 'http'

# Find or create an SsoUser based on Github code
class RetrieveSsoUser
  def self.call(code)
    access_token = get_access_token(code)
    puts access_token
    github_account = get_github_account(access_token)
    puts github_account
    sso_user = find_or_create_sso_user(github_account)
    puts sso_user.to_json
    [sso_user, JWE.encrypt(sso_user)]
  end

  private_class_method

  def self.get_access_token(code)
    HTTP.headers(accept: 'application/json')
        .post('https://github.com/login/oauth/access_token',
              form: { client_id: ENV['GH_CLIENT_ID'],
                      client_secret: ENV['GH_CLIENT_SECRET'],
                      code: code })
        .parse['access_token']
  end

  def self.get_github_account(access_token)
    gh_account = HTTP.headers(user_agent: 'key Secure',
                              authorization: "token #{access_token}",
                              accept: 'application/json')
                     .get('https://api.github.com/user').parse
    { username: gh_account['login'], email: gh_account['email'] }
  end

  def self.find_or_create_sso_user(github_account)
    SsoUser.first(github_account) || SsoUser.create(github_account)
  end
end
