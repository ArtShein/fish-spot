Rails.application.routes.draw do
  get "profiles/show"
  get "profiles/edit"
  get "profiles/update"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    root to: "dashboard#index"
    get "dashboard/index"
    get "geocode/reverse", to: "geocode#reverse", as: :geocode_reverse
    resources :trips do
      collection do
        post :wizard_location
        post :wizard_trip_name
      end
      member do
        get :wizard_fish
      end
    end
    resources :locations
    resources :fish
    resource :profile, only: %i[show edit update]
  end

  # Define your routes according to the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  get "up" => "rails/health#show", as: :rails_health_check

  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
end
