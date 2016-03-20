Rails.application.routes.draw do

  get 'feedback' => 'feedback#feedback_form', as: 'feedback_form'
  post 'feedback' => 'feedback#send_feedback', as: 'send_feedback'


  # Navigateable "Ausleihe"-routes
  get 'ausleihe' => 'ausleihe#index', as: 'ausleihe'
  get 'ausleihe/lent' => 'ausleihe#lent', as: 'ausleihe_lent'
  get 'ausleihe/history' => 'ausleihe#history', as: 'ausleihe_history'
  get 'ausleihe/folders' => 'ausleihe#folders', as: 'ausleihe_folders'
  get 'ausleihe/folders/:id' => 'ausleihe#folder_details', as: 'ausleihe_folder'
  get 'ausleihe/exams' => 'ausleihe#exams', as: 'ausleihe_exams'

  # Routes that should not be manually navigated to in "Ausleihe"
  post 'ausleihe/switch' => 'ausleihe#switch', as: 'ausleihe_switch'
  get  'ausleihe/lending_form' => 'ausleihe#lending_form', as: 'lending_form'
  post 'ausleihe/lending_action' => 'ausleihe#lending_action', as: 'lending_action'
  get  'ausleihe/returning_form' => 'ausleihe#returning_form', as: 'returning_form'
  post 'ausleihe/returning_action' => 'ausleihe#returning_action', as: 'returning_action'

  scope '/internal/admin' do
    get '/' => 'old_folders#index'

    get 'old_folder_instances' => 'old_folder_instances#index', as: 'old_folder_instances'


    resources :old_folders, :old_exams

    get 'old_folders/:old_folder_id/toc' => 'old_folders#toc', as: 'old_folders_toc'

    resources :old_folders do
      resources :old_folder_instances, :old_exams
    end
  end

  namespace :internal do
    root 'internal_application#index'

    namespace :admin do

      get 'lent' => 'lendouts#lent'#, as: 'admin_lent'
      get 'history' => 'lendouts#history'#, as: 'admin_history'


    end

  end

  # Current redirection so that everyone has time to update bookmarks
  get '/admin/*path', to: redirect{ |params, request| "/internal/admin/#{params[:path]}?#{request.query_string}" }

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
