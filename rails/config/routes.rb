Weathersick::Application.routes.draw do

  match '/places/near' => 'places#near'
  match '/nice-weather' => 'home#nice_weather'
  match '/search/flights' => 'search#flights'

  match '/airports/near' => 'airports#near'
  match '/airports/nearest' => 'airports#nearest'
  match '/airports/search' => 'airports#search'
  match '/airports/typeahead' => 'airports#typeahead'

  match '/typeahead-multi' => 'home#typeahead_multi'
  
  resources :places
  resources :airports

  root to: 'home#index'
 
end
