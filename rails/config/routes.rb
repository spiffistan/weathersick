Weathersick::Application.routes.draw do

  match '/places/near' => 'places#near'
  match '/nice-weather' => 'home#nice_weather'
  match '/search/flight' => 'flightsearch#index'

  match '/airports/search' => 'airports#search'
  match '/airports/typeahead' => 'airports#typeahead'
  
  resources :places
  resources :airports

  root to: 'home#index'
 
end
