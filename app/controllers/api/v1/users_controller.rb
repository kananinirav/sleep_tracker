# frozen_string_literal: true

# It's a controller class that has three actions: create, follow and unfollow
class Api::V1::UsersController < ApplicationController
  include Api::V1::UsersControllerDoc
  def create
    user_obj = User.new(user_params)
    service = UserManager.call({ actions: 'create', user_obj: user_obj })
    crete_response_from_service(service)
  end

  def follow
    service = UserFriendshipManager.call({ actions: 'follow', following_user_id: params[:following_id],
                                           current_user: current_user })
    crete_response_from_service(service)
  end

  def unfollow
    service = UserFriendshipManager.call({ actions: 'un-follow', following_user_id: params[:following_id],
                                           current_user: current_user })
    crete_response_from_service(service)
  end

  private

  def user_params
    params.require(:user).permit(:user_name)
  end
end
