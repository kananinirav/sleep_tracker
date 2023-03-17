# frozen_string_literal: true

# It's a controller to manage sleep tracking related actions.
module Api
  module V1
    module SleepTrackingsControllerDoc
      extend Apipie::DSL::Concern

      api :GET, '/api/v1/users/:user_id/sleep_trackings', 'User Friends Last Week Sleep Tracking Records'
      param :user_id, :number, desc: 'user_id of the requested user', required: true
      example <<-EDOC
      $ curl --location 'http://localhost:3000/api/v1/users/:user_id/sleep_trackings'
        # User not found
        {
          "success": false,
          "message": null,
          "errors": [
              "Record not found"
          ]
        }

        # Data not preset for friends
        {
          "success": true,
          "message": null,
          "data": []
        }

        # success response
        {
          "success": true,
          "message": null,
          "data": [
            {
              "user_id": 2,
              "user_name": "nirav",
              "sleep_trackings": [
                  {
                    "id": 12,
                    "user_id": 2,
                    "clock_in": "2023-03-17 10:09:29",
                    "clock_out": "2023-03-17 11:04:09",
                    "sleep_duration_second": 3280,
                    "sleep_duration_hour": "0:54:40"
                  }
              ]
            }
          ]
        }
      EDOC
      def index
        # for api doc
      end

      api :POST, '/api/v1/users/:user_id/sleep_trackings/clock_in', 'Clock In Event'
      param :user_id, :number, desc: 'user_id of the requested user', required: true
      example <<-EDOC
      $ curl --location --request POST 'http://localhost:3000/api/v1/users/:user_id/sleep_trackings/clock_in'
        # User not found
        {
          "success": false,
          "message": null,
          "errors": [
              "Record not found"
          ]
        }

        # clocked in successfully
        {
          "success": true,
          "message": "clocked in successfully",
          "data": [
            {
              "id": 14,
              "user_id": 2,
              "clock_in": "2023-03-17T14:46:24.005+09:00",
              "clock_out": null,
              "sleep_duration": null,
              "created_at": "2023-03-17T14:46:24.006+09:00",
              "updated_at": "2023-03-17T14:46:24.006+09:00"
            },
            {
              "id": 12,
              "user_id": 2,
              "clock_in": "2023-03-17T10:09:29.450+09:00",
              "clock_out": "2023-03-17T11:04:09.936+09:00",
              "sleep_duration": 3280,
              "created_at": "2023-03-17T10:09:29.450+09:00",
              "updated_at": "2023-03-17T11:04:09.937+09:00"
            }
          ]
        }

        # when clock in again without clock out
        {
          "success": true,
          "message": "you need to clock out first",
          "data": null
        }
      EDOC
      def clock_in
        # for api doc
      end

      api :PATCH, '/api/v1/users/:user_id/sleep_trackings/clock_out', 'Clock Out Event'
      param :user_id, :number, desc: 'user_id of the requested user', required: true
      example <<-EDOC
      $ curl --location --request PATCH 'http://localhost:3000/api/v1/users/:user_id/sleep_trackings/clock_out'
        # User not found
        {
          "success": false,
          "message": null,
          "errors": [
              "Record not found"
          ]
        }

        # clocked out successfully
        {
          "success": true,
          "message": "clocked out successfully",
          "data": null
        }

        # when clock out without clock in
        {
          "success": true,
          "message": "you need to clock in first",
          "data": null
        }
      EDOC
      def clock_out
        # for api doc
      end
    end
  end
end
