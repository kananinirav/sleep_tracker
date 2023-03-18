# frozen_string_literal: true

# It's a controller to manage sleep tracking related actions.
module Api
  module V1
    module UsersControllerDoc
      extend Apipie::DSL::Concern

      api :POST, '/v1/users', 'Create User'
      param :user, Hash, desc: 'User Object' do
        param :user_name, String, desc: 'User Name', required: true
      end
      example <<-EDOC
      curl --location 'http://localhost:3000/api/v1/users' --header 'Content-Type: application/json' --data '{ "user": { "user_name": "", "user_id": "" } }'

      # when unpermitted parameter present
      {
        "success": false,
        "message": null,
        "errors": [
          "found unpermitted parameter: :user_id"
        ]
      }

      # when user name blank
      {
        "success": false,
        "message": "please check required fields",
        "errors": [
          "User name can't be blank"
        ]
      }

      # user successfully created
      {
        "success": true,
        "message": "user successfully created",
        "data": {
          "id": 13,
          "user_name": "test user",
          "created_at": "2023-03-17T15:06:50.191+09:00",
          "updated_at": "2023-03-17T15:06:50.191+09:00"
        }
      }
      EDOC
      def create
        # for api doc
      end

      api :POST, '/v1/users/:user_id/follow/:following_id', 'Follow User'
      param :user_id, :number, desc: 'user_id of the requested user', required: true
      param :following_id, :number, desc: 'user id you want to follow user', required: true
      example <<-EDOC
        curl --location --request POST 'http://localhost:3000/api/v1/users/:user_id/follow/:following_id'

        # when user id not found
        {
          "success": false,
          "message": null,
          "errors": [
            "Record not found"
          ]
        }
        # when following_id user not found
        {
          "success": true,
          "message": "Following User not found",
          "data": null
        }

        # when Already following to user
        {
          "success": true,
          "message": "kanani Already following to nirav",
          "data": null
        }

        # when successful following to user
        {
          "success": true,
          "message": "kanani started following to Test ",
          "data": null
        }
      EDOC

      def follow
        # for api doc
      end

      api :DELETE, '/v1/users/:user_id/unfollow/:following_id', 'Un-Follow User'
      param :user_id, :number, desc: 'user_id of the requested user', required: true
      param :following_id, :number, desc: 'user id you want to follow user', required: true
      example <<-EDOC
        curl --location --request DELETE 'http://localhost:3000//api/v1/users/:user_id/unfollow/:following_id'

        # when user id not found
        {
          "success": false,
          "message": null,
          "errors": [
            "Record not found"
          ]
        }
        # when following_id user not found
        {
          "success": true,
          "message": "Following User not found",
          "data": null
        }

        # when user not following to user
        {
          "success": true,
          "message": "kanani not following jeffrey",
          "data": null
        }

        # when successful un-following to user
        {
          "success": true,
          "message": "kanani un-following Test",
          "data": null
        }
      EDOC

      def unfollow
        # for api doc
      end
    end
  end
end
