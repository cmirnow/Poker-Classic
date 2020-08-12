Rails.application.routes.draw do
    root 'poker#index'
    post '/', to: 'poker#index'
end
