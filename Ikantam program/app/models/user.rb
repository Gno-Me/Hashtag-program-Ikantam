class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
         :trackable, :validatable, :omniauthable, :confirmable

  has_one :identity
  has_and_belongs_to_many :hashtags

  validates :password, length: { minimum: 8 }, unless: Proc.new { |user| user.password.nil? }


  def self.find_for_oauth(auth, signed_in_resource = nil)

    # Get the identity and user if they exist
    identity = Identity.find_for_oauth(auth)

    # If a signed_in_resource is provided it always overrides the existing user
    # to prevent the identity being locked with accidentally created accounts.
    # Note that this may leave zombie accounts (with no associated identity) which
    # can be cleaned up at a later date.
    user = signed_in_resource ? signed_in_resource : identity.user

    # Create the user if needed
    if user.nil?

      # Get the existing user by email if the provider gives us a verified email.
      # If no verified email was provided we assign a temporary email and ask the
      # user to verify it on the next step via UsersController.finish_signup
            # Rails.logger.debug '************SSS***************'
            # Rails.logger.debug auth.uid.to_s
            # Rails.logger.debug '************SSS***************'
            # Rails.logger.debug auth.to_s
            # Rails.logger.debug '************SSS***************'
            # Rails.logger.debug auth.info.to_s
            # Rails.logger.debug '************SSS***************'
            # Rails.logger.debug auth.extra.raw_info.verified.to_s
            # Rails.logger.debug '************SSS***************'
            # Rails.logger.debug auth.extra.raw_info.verified_email.to_s
            # Rails.logger.debug '************SSS***************'
            # Rails.logger.debug auth.extra.to_s
            # Rails.logger.debug '************XXX***************'
      email = auth.info.email
      user = User.where(:email => email).first if email

      # Create the user if it's a new registration
      if user.nil?
        user = User.new(
          first_name: auth.info.first_name,
          last_name: auth.info.last_name,
          username: auth.info.nickname || "#{identity.provider}-#{identity.id}",
          email: email ? email : "change@me-#{auth.uid}-#{auth.provider}.com",
          password: Devise.friendly_token[0,20]
        )
        user.skip_confirmation!
        user.save!
      end
    end

    # Associate the identity with the user if needed
    if identity.user != user
      identity.user = user
      identity.save!
    end
    user
   end

   def email_verified?
     self.email && self.email !~ /change@me/
   end

  # Clientside validation helper
  # client call /users/validate and receive data about persistance of that user
  # @param options [hash] (email: 'example@gmail.com')
  # @return [boolean] <self-explainable>
  def self.validate_params options = {}
    user = find_by(options)
    return !user
  end

  def display_name
    if first_name && last_name
      "#{first_name} #{last_name}"
    elsif username
      username
    else
      '(unknown)'
    end
  end
end

