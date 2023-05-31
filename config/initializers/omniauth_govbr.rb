module OmniAuth
  module Strategies
    class OpenIDConnect
      info do
        name = user_info.name.split(' ').first
        nickname = name.parameterize[0,10] << '_' << rand.to_s[2..10]

        {
          name: name,
          email: user_info.email,
          email_verified: user_info.email_verified,
          nickname: nickname,
          phone: user_info.phone_number,
          phone_number_verified: user_info.phone_number_verified
        }
      end
    end
  end
end

Devise.setup do |config|
  config.omniauth :openid_connect, {
    name: :govbr,
    scope: [:openid, :email, :profile, :govbr_confiabilidades],
    grant_type: 'authorization_code',
    issuer: "https://#{ENV['OMNIAUTH_GOVBR_HOST']}/",
    client_auth_method: 'jwks',
    pkce: true,
    client_options: {
      host: ENV["OMNIAUTH_GOVBR_HOST"],
      identifier: ENV["OMNIAUTH_GOVBR_CLIENT_ID"],
      secret: ENV["OMNIAUTH_GOVBR_SECRET_KEY"],
      redirect_uri: ENV["OMNIAUTH_GOVBR_REDIRECT_URI"],
      jwks_uri: "https://#{ENV['OMNIAUTH_GOVBR_HOST']}/jwk"
    }
  }
end