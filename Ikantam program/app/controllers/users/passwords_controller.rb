class Users::PasswordsController < Devise::PasswordsController

  def successfuly_sent
    # empty action
  end

  protected

  def after_sending_reset_password_instructions_path_for(resource_name)
    users_password_success_path
  end
end