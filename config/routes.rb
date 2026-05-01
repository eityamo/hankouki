Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    root 'records#new'
    get '/records', to: 'records#new'
    get 'terms', to: 'records#terms'
    get 'privacy_policy', to: 'records#privacy_policy'
    resources :records, only: %i[create]
  end
end
