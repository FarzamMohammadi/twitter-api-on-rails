Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      resources :users, only: [:create]
      resources :chats, only: [:index, :create]
      resources :tweets, only: [:index, :create, :update, :destroy]
    end
  end
end
