Rails.application.routes.draw do
  root to: 'users#profile'

  get "/profile", to: "users#profile"
  patch "/profile", to: "users#update"
  delete "/profile", to: "users#delete"

  get "/users/is_authorized", to: "users#is_authorized?"

  get '/sign_in', to: 'users#sign_in'
  post '/sign_in', to: 'users#sign_in!'
  get '/sign_up', to: 'users#sign_up'
  post '/sign_up', to: 'users#sign_up!'
  get '/sign_out', to: 'users#sign_out'
  # students submissions end-point
  get 'api/memberships/:id/submissions', to: "submissions_api#index"

  # groups api routes
  get 'api/groups', to: "groups_api#index"
  get 'api/groups/:id', to: "groups_api#students"
  get 'api/groups/:id/attendance_summary', to: "groups_api#students_attendances"
  get 'api/groups/:id/submission_summary', to: "groups_api#students_submissions"

  get "github/authorize", to: "users#gh_authorize"
  get "github/authenticate", to: "users#gh_authenticate"

  patch 'update_attendance', to: "attendances_api#update"

  get "/report_card/:id", to: 'groups#report_card'

  get '/groups/:group_id/names', to: 'groups#names'
  resources :groups do
    resources :events do
      resources :attendances
    end
    resources :assignments do
      resources :submissions
    end
    resources :memberships do
      resources :observations
    end
    resources :students do
      resources :observations
    end
  end

end
