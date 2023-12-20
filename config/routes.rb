Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  resources :entries, path: '/breakpoint', only: [:index, :new, :edit, :create, :update] do
    collection do
      get '/*entry_path', to: 'entries#show', as: 'entry', constraints: { entry_path: %r|\d{4}/\d{2}/\d{2}/\d{6}| }
    end
  end
end
