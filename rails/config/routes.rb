Weathersick::Application.routes.draw do

  match '/places/near' => 'places#near'
  match '/nice-near' => 'home#nice_near'
  match '/search/flight' => 'home#flight_search'
  match '/search/flight' => 'home#flight_search'

  match '/airports/search' => 'airports#search'
  match '/airports/typeahead' => 'airports#typeahead'
  
  resources :places
  resources :airports

  root to: 'home#index'
 
end
