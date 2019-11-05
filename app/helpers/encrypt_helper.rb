module EncryptHelper
  def encrypt(unencrypted_email, secure_mode_salt)
    encryptor = ::ActiveSupport::MessageEncryptor.new(secure_mode_salt, cipher: 'aes-256-cbc')
    e = encryptor.encrypt_and_sign(unencrypted_email)
    return e
  end
end