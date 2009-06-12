ActionController::Routing::Routes.draw do |map|
  map.resource  :session
  map.resources :hltbs
  map.resources :users
  map.resources :helpers
  map.resources :counters
  map.root      :controller => "hltbs"
  map.connect   ':controller/:action/:id'
  map.connect   ':controller/:action/:id.:format'
end
