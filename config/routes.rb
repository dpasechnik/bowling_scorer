Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/docs/api'
  mount Rswag::Ui::Engine => '/'

  namespace :v1 do
    resource :game
  end
end
