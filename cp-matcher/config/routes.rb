Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :status, only: [:index]

      namespace :ocr do
        namespace :invoice do
          resources :find_company, only: [:create]
        end
      end
    end
  end
end
