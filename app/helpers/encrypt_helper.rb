module EncryptHelper
  def encrypt(unencrypted_email, secure_mode_salt)
    c = OpenSSL::Cipher.new("aes-256-cbc")
    c.encrypt()
    c.key = Digest::SHA256.digest(unencrypted_email)
    binding.pry
    e = c.update(secure_mode_salt)
    e << c.final
    return e
  end
end