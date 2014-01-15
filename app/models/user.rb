require 'digest'
class User < ActiveRecord::Base
  attr_accessor :password

  # Adding the validation for User model.
  validates_uniqueness_of :email
  validates_length_of :email, :within => 5..50
  validates_format_of :email, :with => /[^@][\w.-]+@[\w.-]+[.][a-z]{2,4}/i
  validates_confirmation_of :password
  before_save :encrypt_new_password
  # Adding the relationship between the User model with other models such as
  # A user has just only a profile
  # A user has many entry item, and also has more than one reply (comment)
  has_one :profile
  has_many :entries, -> { order('published_at DESC, title ASC')} , :dependent => :nullify
  has_many :replies, :though => :articles, :source => :comments

  # Method 'authenticate' used to check the specified email and also password,
  # Looking up the email, then checking it out from the database and its password.
  # @param email, password
  def self.authenticate email, password
    user = find_by_email(email)
    return user if user && user.authenticated?(password)
  end
  # Method authentication and encryption
  # @param password
  def authenticated?(password)
    self.hashed_password == encrypt(password)
  end

  protected
    #Method 'encrypt_new_password' used to encrypt the password..
    #
    def encrypt_new_password
      return if password.blank?
      self.hashed_password = encrypt(password)
    end
    #Method used to check the password must to be required
    #
    def password_require?
      hashed_password.blank? || password.present?
    end

    #Method used to encrypt a string to hexa digital characters,
    #@param string
    def encrypt string
      Digest::SHA1.hexdigest(string)
    end
end
