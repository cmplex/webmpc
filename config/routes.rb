# vim: tabstop=2 shiftwidth=2 expandtab
Webmpc::Application.routes.draw do
  devise_for :users
  get     'users',                to: 'users#index',                as: 'users'
  get     'users/:id/edit',       to: 'users#edit',                 as: 'edit_user'
  patch   'users/:id',            to: 'users#update',               as: 'user'
  delete  'users/:id',            to: 'users#destroy'

  get     'now_playing',          to: 'now_playing#index'
  get     'playlist',             to: 'playlist#index'
  get     'browse',               to: 'browse#index'
  get     'search',               to: 'search#index'

  post    'mpd/prev',                 to: 'now_playing#prev'
  post    'mpd/next',                 to: 'now_playing#next'
  post    'mpd/toggle',               to: 'now_playing#toggle'
  post    'mpd/volUp',                to: 'now_playing#volUp'
  post    'mpd/volDown',              to: 'now_playing#volDown'
  post    'mpd/seek',                 to: 'now_playing#seek'
  get     'mpd/song_info',            to: 'now_playing#songInfo'
  get     'mpd/cover',                to: 'now_playing#albumarturl'

  post    'mpd/play',                 to: 'playlist#play'
  post    'mpd/clear',                to: 'playlist#clear'
  get     'mpd/playlist',             to: 'playlist#playlist'

  get     'playlist/refresh_playlist', to: 'playlist#refresh_playlist'

  get     'mpd/search',               to: 'search#search'
  post    'mpd/search_mobile',        to: 'search#search_mobile'
  post    'mpd/addResult',            to: 'search#addResult'
  post    'mpd/addAll',               to: 'search#addAll'

  get     'mpd/listArtists',      to: 'browse#listArtists'
  get     'mpd/listAlbums',       to: 'browse#listAlbums'
  get     'mpd/listSongs',        to: 'browse#listSongs'
  post    'mpd/addSong',          to: 'browse#addSong'
  post    'mpd/updateDatabase',   to: 'browse#updateDatabase'

  post    'browse/browse_artists',  to: 'browse#browse_artists'
  post    'browse/browse_albums',   to: 'browse#browse_albums'
  post    'browse/browse_songs',    to: 'browse#browse_songs'

  post    'voting/hype'
  post    'voting/hate'
  post    'voting/reset'

  get     'settings',                 to: 'settings#index'
  patch   'settings/:id',             to: 'settings#update',        as: 'setting'

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
