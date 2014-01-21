Spree::Core::Engine.routes.draw do


#  resources :importations


  # Add your extension routes here
  namespace :admin do
    match '/importation_process/:action/:id' => 'importation_process#view'
    resources :importations
    resources :importation_attachments  
      
  end
  
end
