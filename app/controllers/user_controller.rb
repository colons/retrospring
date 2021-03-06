class UserController < ApplicationController
  before_filter :authenticate_user!, only: %w(edit update edit_privacy update_privacy data)

  def show
    @user = User.where('LOWER(screen_name) = ?', params[:username].downcase).first!
    @answers = @user.answers.reverse_order.paginate(page: params[:page])

    if user_signed_in?
      notif = Notification.where(target_type: "Relationship", target_id: @user.active_relationships.where(target_id: current_user.id).pluck(:id), recipient_id: current_user.id, new: true).first
      unless notif.nil?
        notif.new = false
        notif.save
      end
    end

    respond_to do |format|
      format.html
      format.js
    end
  end

  # region Account settings
  def edit
  end

  def update
    user_attributes = params.require(:user).permit(:display_name, :profile_picture, :profile_header, :motivation_header, :website,
                                                   :location, :bio, :crop_x, :crop_y, :crop_w, :crop_h, :crop_h_x, :crop_h_y, :crop_h_w, :crop_h_h)
    if current_user.update_attributes(user_attributes)
      text = t('flash.user.update.text')
      text += t('flash.user.update.avatar') if user_attributes[:profile_picture]
      text += t('flash.user.update.header') if user_attributes[:profile_header]
      flash[:success] = text
    else
      flash[:error] = t('flash.user.update.error')
    end
    redirect_to edit_user_profile_path
  end
  # endregion

  # region Privacy settings
  def edit_privacy
  end

  def update_privacy
    user_attributes = params.require(:user).permit(:privacy_allow_anonymous_questions,
                                                   :privacy_allow_public_timeline,
                                                   :privacy_allow_stranger_answers,
                                                   :privacy_show_in_search)
    if current_user.update_attributes(user_attributes)
      flash[:success] = t('flash.user.update_privacy.success')
    else
      flash[:error] = t('flash.user.update_privacy.error')
    end
    redirect_to edit_user_privacy_path
  end
  # endregion

  # region Groups
  def groups
    @user = User.where('LOWER(screen_name) = ?', params[:username].downcase).first!
    @groups = if current_user == @user
                @user.groups
              else
                @user.groups.where(private: false)
              end.all
  end
  # endregion

  def followers
    @title = 'Followers'
    @user = User.where('LOWER(screen_name) = ?', params[:username].downcase).first!
    @users = @user.followers.reverse_order.paginate(page: params[:page])
    @type = :friend
    render 'show_follow'
  end

  def friends
    @title = 'Following'
    @user = User.where('LOWER(screen_name) = ?', params[:username].downcase).first!
    @users = @user.friends.reverse_order.paginate(page: params[:page])
    @type = :friend
    render 'show_follow'
  end

  def questions
    @title = 'Questions'
    @user = User.where('LOWER(screen_name) = ?', params[:username].downcase).first!
    @questions = @user.questions.where(author_is_anonymous: false).reverse_order.paginate(page: params[:page])
  end

  def data
  end
end
