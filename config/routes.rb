Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.map(&:to_s).join("|")}/ do
    root 'records#new'
    get '/records', to: 'records#new'
    get 'terms', to: 'records#terms'
    get 'privacy_policy', to: 'records#privacy_policy'
    resources :records, only: %i[create]
  end

  # 動的エラーページ
  match '/404', to: 'errors#not_found', via: :all
  match '/500', to: 'errors#internal_server_error', via: :all
end
