# frozen_string_literal: true
module JsonWebToken
  ALG = 'HS256'

  module_function

  def encode(payload)
    unless payload.is_a?(Hash)
      raise ArgumentError.new('You must specify Hash instance.')
    end

    JWT.encode(payload, key, ALG)
  end

  def decode(token)
    decoded_token = JWT.decode(token, key, true, algorithm: ALG)

    HashWithIndifferentAccess.new(decoded_token[0])
  end

  def key
    Rails.application.credentials.secret_key_base
  end
end
