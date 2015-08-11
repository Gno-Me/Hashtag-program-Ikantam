class HashtagsController < ApplicationController

  before_action :authenticate_user!
  load_and_authorize_resource

  # Show first user keyword by default
  def index
    @hashtags = current_user.hashtags
    @hashtag = @hashtags.first

    if @hashtag
      @posts = @hashtag.latest_posts.paginate(page: params[:page])
    else 
      @posts = []
    end

    render 'show'
  end

  # Show particular user keyword by id
  def show
    @hashtag = Hashtag.find(params[:id])
    @hashtags = current_user.hashtags
    @posts = @hashtag.latest_posts.paginate(page: params[:page])
  end

  # Create new hashtag or restore deleted one
  def create

    @hashtag = Hashtag.find_by(hashtag_params)

    if @hashtag.present?
      if @hashtag.users.include?(current_user)
        @hashtag.errors.add(:name, 'already exists')
      else
        @hashtag.users << current_user
      end
    else
      @hashtag = Hashtag.new(hashtag_params)
      @hashtag.users << current_user
    end

    if @hashtag.errors.empty? && @hashtag.save
      response = @hashtag
      status = 200
    else
      response = @hashtag.errors.messages
      status = 422
    end

    respond_to do |format|
      format.json { render json: response, status: status }
    end
  end

  # Remove hashtag
  def destroy
    @hashtag = Hashtag.find(params[:id])
    @hashtag.users.delete(current_user)
    redirect_to :authenticated_root
  end

  private

  # Filter parameters for 'create' method
  def hashtag_params
    params.require(:hashtag).permit(:name)
  end

end