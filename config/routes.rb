Rails.application.routes.draw do
  namespace "api" do
    resources :posts, only: [:index]
    # get "/api/posts", to: "posts#index"
  end
  # RESTful actions: index, show, new, create, edit, update, delete, search
end
