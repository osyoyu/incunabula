Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  scope :blog do
    root to: 'entries#index'
    resources :entries, only: [:new, :create, :update]

    # Give lowest precendence
    get '/*entry_path', to: 'entries#show', as: 'entry_friendly', constraints: { entry_path: %r|\d{4}/\d{2}/\d{2}/\d{6}| }
    get '/*entry_path/edit', to: 'entries#edit', as: 'edit_entry_friendly', constraints: { entry_path: %r|\d{4}/\d{2}/\d{2}/\d{6}| }
  end
end
