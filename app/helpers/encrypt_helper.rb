module EncryptHelper
  def encrypt(unencrypted_email, secure_mode_salt)
    key_len = ActiveSupport::MessageEncryptor.key_len('aes-256-cbc')
    salt = SecureRandom.random_bytes(64)
    key = ActiveSupport::KeyGenerator.new(secure_mode_salt).generate_key(secure_mode_salt + secure_mode_salt, key_len)
    c = ::ActiveSupport::MessageEncryptor.new(key, cipher: 'aes-256-cbc')
    e = c.encrypt_and_sign(unencrypted_email)
    # eが暗号化した値、fが複合化した値
    f = c.decrypt_and_verify(e)
    binding.pry
    return e
  end
end