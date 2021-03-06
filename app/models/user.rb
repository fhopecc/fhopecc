require 'digest/sha1'
class User < ActiveRecord::Base
  # Virtual attribute for the unencrypted password
  attr_accessor :password
	has_one  :tag_tree, :dependent => :destroy
	has_many :mlogs, :dependent => :destroy
	has_many :monthly_mlogs

  #validates_presence_of     :login, :email
  validates_presence_of :login, :message => "帳號不可空白！ "
	                    
  validates_presence_of :password, :if => :password_required?, 
                        :message => "密碼不可空白！ "
  validates_presence_of :password_confirmation, 
	                      :if => :password_required?, 
                        :message => "密碼確認不可空白！ "

  validates_length_of :password, :within => 4..40, 
		                  :if => :password_required?,
											:too_short => "密碼至少要 %d 個字！", 
											:too_long => "密碼不可超出 %d 個字！" 

  validates_confirmation_of :password, :if => :password_required?, 
		                        :message => "密碼與密碼確認不一致！"

  validates_length_of :login, :within => 3..40, 
											:too_short => "帳號至少要 %d 個字！", 
											:too_long => "帳號不可超出 %d 個字！" 

  #validates_length_of       :email,    :within => 3..100
  #validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_uniqueness_of :login, :case_sensitive => false, 
		                      :message => "帳號已有人使用！"
  before_save :encrypt_password
  
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation

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

	#has_many monthly_mlogs
	def monthly_mlogs
		MMS.new self
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

	class MMS
    attr_accessor :user
		def initialize user
			@user = user
			if @user.tag_tree.nil?
			  @user.create_tag_tree
			end
		end

		def find mon
			MonthlyMlog.find_by_user_and_mon user, mon 
		end
	end
end
