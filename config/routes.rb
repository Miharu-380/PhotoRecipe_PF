Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # ========== ユーザー(user) ==========
  devise_for :users, controllers: {
        sessions: 'public/sessions',
        registrations: 'public/registrations',
  }

  devise_scope :user do
    post 'users/guest_sign_in' => 'public/sessions#guest_sign_in'
  end

  scope module: :public do
    root to: 'homes#top'
    get 'index' => 'homes#index'

    resources :posts do
      resources :reviews, only: [:create, :destroy]
      resources :likes, only: [:create, :destroy]
      resources :bookmarks, only: [:create, :destroy]
      collection do
        get 'search'
        get 'm_search' => 'posts#mobile_search'
        get 'weekly_rank' => 'posts#weekly_rank'
      end
    end

    get '/posts/:id/likes' => 'posts#like', as: 'like_index'
    get '/post/hashtag/:name' => 'posts#hashtag'

    resources :contacts, only: [:new, :create] do
      collection do
        post 'confirm' => 'contacts#confirm', as: 'contacts_confirm'
        post 'back' => 'contacts#back'
        get 'done' => 'contacts#done'
      end
    end

    resources :users, only: [:show, :edit, :update, :destroy] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      member do
        get 'unsubscribe' => 'users#unsubscribe', as: 'unsubscribe'
        get 'bookmark' => 'users#bookmark', as: 'bookmark'
      end
    end

    get 'users/timeline' => 'users#timeline', as: 'timeline'
  end

  # # ========== 管理者(admin) ==========
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    registrations: 'admins/registrations',
    passwords: 'admins/passwords',
  }

  namespace :admin do
    root to: 'homes#top'
    resources :users, only: [:index, :show, :edit, :update]
  end
end
