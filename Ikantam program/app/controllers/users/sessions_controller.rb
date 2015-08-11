class Users::SessionsController < Devise::SessionsController

  def new
    flash[:registration_gateway] = 'plain'
    super
  end


  def create
    user = User.find_by_email(params[:user][:email])
    if flash[:registration_gateway] == 'plain'
      if user.present? && user.identity.present?
        flash[:alert] = 'This user was registered using authorization option.'
        redirect_to new_user_session_path
        return
      end
    end
    super
  end

end
