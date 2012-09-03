Weathersick::Application.routes.draw do

  match '/places/near' => 'places#near'
  match '/nice-near' => 'home#nice_near'
  match '/search/flight' => 'home#flight_search'
  
  resources :places

  root to: 'home#index'
 
end
