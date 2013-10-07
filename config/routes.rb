# vim: tabstop=2 shiftwidth=2 expandtab
Webmpc::Application.routes.draw do
  devise_for :users
  get     'users',          to: 'users#index',  as: 'users'
  get     'users/:id/edit', to: 'users#edit',   as: 'edit_user'
  patch   'users/:id',      to: 'users#update', as: 'user'
  delete  'users/:id',      to: 'users#destroy'

  post    'mpc/prev',             to: 'now_playing#prev'
  post    'mpc/next',             to: 'now_playing#next'
  post    'mpc/toggle',           to: 'now_playing#toggle'
  post    'mpc/volUp',            to: 'now_playing#volUp'
  post    'mpc/volDown',          to: 'now_playing#volDown'
  post    'mpc/seek',             to: 'now_playing#seek'
  get     'mpc/currentArtist',    to: 'now_playing#currentArtist'
  get     'mpc/currentAlbum',     to: 'now_playing#currentAlbum'
  get     'mpc/currentTitle',     to: 'now_playing#currentTitle'
  get     'mpc/currentProgress',  to: 'now_playing#currentProgress'

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'now_playing#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
