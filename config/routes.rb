Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :users, only: [:create] do
        post 'follow/:following_id', to: 'users#follow', as: 'follow'
        delete 'unfollow/:following_id', to: 'users#unfollow', as: 'unfollow'

        resources :sleep_trackings, only: [:index] do
          collection do
            post 'clock_in', to: 'sleep_trackings#clock_in'
            patch 'clock_out', to: 'sleep_trackings#clock_out'
          end
        end
      end
    end
  end
end
