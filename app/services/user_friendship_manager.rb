# frozen_string_literal: true

# It's a service class that manages the user's following and un-following actions
class UserFriendshipManager < ApplicationService
  def initialize(options)
    @actions = options[:actions]
    @following_user_id = options[:following_user_id]
    @current_user = options[:current_user]
    @service_result = ServiceResult.new('User Friendships Manager')
  end

  def call
    case @actions
    when 'follow'
      follow
    when 'un-follow'
      unfollow
    end
    @service_result
  rescue => e
    Rails.logger.info e
  end

  # write all required private method to full-fill service call
  private

  def follow
    following_user = User.find_by(id: @following_user_id)
    if following_user.nil?
      @service_result.data = { message: 'Following User not found' }
      return
    end

    friendship_check = @current_user.user_friendships.find_by(following_user_id: following_user.id)
    if friendship_check.present?
      @service_result.data = { message: "#{@current_user.user_name} Already following to #{following_user.user_name}" }
    else
      @current_user.following_users << following_user
      @service_result.data = { message: "#{@current_user.user_name} started following to #{following_user.user_name} " }
    end
  end

  def unfollow
    following_user = User.find_by(id: @following_user_id)
    message = if following_user
                following_list_checks(following_user)
              else
                'Following User not found'
              end
    @service_result.data = { message: message }
  end

  def following_list_checks(following_user)
    friendship = @current_user.user_friendships.find_by(following_user_id: following_user.id)
    if friendship
      friendship.destroy
      "#{@current_user.user_name} un-following #{following_user.user_name}"
    else
      "#{@current_user.user_name} not following #{following_user.user_name}"
    end
  end
end
