Rails.application.routes.draw do
  resources :images do
    get :moderate
    get :unmoderate
    get :rude
    get :unrude
    get :funny
    get :unfunny
  end
  get 'welcome/update_slideshow'
  # TODO: fix this
  get 'welcome/reboot_server'
  get 'welcome/index'
  root 'welcome#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
