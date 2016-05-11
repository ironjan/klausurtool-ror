Rails.application.routes.draw do

  get 'feedback' => 'feedback#feedback_form', as: 'feedback_form'
  post 'feedback' => 'feedback#send_feedback', as: 'send_feedback'


  scope '/internal' do
    scope '/ausleihe' do

      # Navigateable "Ausleihe"-routes
      get '/' => 'ausleihe#index', as: 'ausleihe'
      get '/lent' => 'ausleihe#lent', as: 'ausleihe_lent'
      get '/history' => 'ausleihe#history', as: 'ausleihe_history'
      get '/folders' => 'ausleihe#folders', as: 'ausleihe_folders'
      get '/folders/:id' => 'ausleihe#folder_details', as: 'ausleihe_folder'
      get '/exams' => 'ausleihe#exams', as: 'ausleihe_exams'

      # Routes that should not be manually navigated to in "Ausleihe"
      post '/switch' => 'ausleihe#switch', as: 'ausleihe_switch'
      get '/lending_form' => 'ausleihe#lending_form', as: 'lending_form'
      post '/lending_action' => 'ausleihe#lending_action', as: 'lending_action'
      get '/returning_form' => 'ausleihe#returning_form', as: 'returning_form'
      post '/returning_action' => 'ausleihe#returning_action', as: 'returning_action'
    end

    scope '/admin' do
      get '/' => 'old_folders#index'

      get 'old_folder_instances' => 'old_folder_instances#index', as: 'old_folder_instances'
      get 'old_folder_instances/:barcode/cover' => 'internal/admin/print#cover', as: 'cover'


      resources :old_folders, :old_exams

      get 'old_folders/:old_folder_id/toc' => 'internal/admin/print#toc', as: 'old_folders_toc'
      resources :old_folders do
        resources :old_folder_instances, :old_exams
      end
    end
  end

  namespace :internal do
    root 'internal_application#index'

    namespace :admin do

      get 'lent' => 'lendouts#lent'
      get 'history' => 'lendouts#history'

    end

  end

  # Current redirection so that everyone has time to update bookmarks
  get '/ausleihe', to: redirect { "/internal/ausleihe/" }
  get '/ausleihe/*path', to: redirect { |params, request| "/internal/ausleihe/#{params[:path]}?#{request.query_string}" }
  get '/admin', to: redirect { "/internal/admin/" }
  get '/admin/*path', to: redirect { |params, request| "/internal/admin/#{params[:path]}?#{request.query_string}" }

  root 'application#index'

end
