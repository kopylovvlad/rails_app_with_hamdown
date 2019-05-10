Rails.application.routes.draw do
  root 'welcome#index'
  get '/hello', to: 'welcome#index'
end
