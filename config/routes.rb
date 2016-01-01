Rails.application.routes.draw do

  post 'ausleihe/switch'            => 'old_lend_outs#switch',           as: 'ausleihe_switch'
  get  'ausleihe/lending_form'      => 'old_lend_outs#lending_form',     as: 'lending_form'
  post 'ausleihe/lending_action'    => 'old_lend_outs#lending_action',   as: 'lending_action'
  get  'ausleihe/returning_form'    => 'old_lend_outs#returning_form',   as: 'returning_form'
  post 'ausleihe/returning_action'  => 'old_lend_outs#returning_action', as: 'returning_action'
  get  'old_folder_instances'       => 'old_folder_instances#index',     as: 'old_folder_instances'

  resources :old_folders, :old_exams
  resources :old_lend_outs, path: "ausleihe"

  resources :old_folders do
    resources :old_folder_instances, :old_exams
  end

  get '/search' => 'old_exams#index'

  root 'application#index'

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
