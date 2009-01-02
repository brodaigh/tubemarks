require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
  has_many :marks
  has_many :marked_videos, :through => :marks, :source => :video
  has_many :views
  has_many :viewed_videos, :through => :views, :source => :video
  
  #redundant with length_of validation xB
  #validates_presence_of     :login, :email
  #validates_presence_of     :password,                   :if => :password_required?
  
  #agree with Amy Hoy -no password_field so no need to write it twice. xB
  #validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?, :message => "password too short"
  #validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40, :message => "hi"
  validates_length_of       :email,    :within => 3..100, :message => "bye too short"
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password
  

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password#, :password_confirmation

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def is_admin?
    admins = ['mike', 'brodaigh']
    login && admins.include?(login)
  end

  def self.generate_forgotten_password_link(email)
    user = User.find(:first, :conditions => ["email = ?", email ])
    if user
      user.forgotten_password_link = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{user.email}--")
      user.save!
      return user
    end
    return nil
  end

  def self.reset_password_through_link(link, new_password)#, new_password_confirmation)
    users = User.find(:all, :conditions => ["forgotten_password_link = ?", link])
    raise "Whoa sailor, something's not right here" if users.size > 1
    if users.size > 0
      user = users.first
      user.password = new_password
      #user.password_confirmation = new_password_confirmation
      user.save!
      user.forgotten_password_link = nil # we know its all OK so we stop the link being used again.
      user.save!
      return user
    else
      return nil
    end
  end

  protected
    # before filter
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end


end
