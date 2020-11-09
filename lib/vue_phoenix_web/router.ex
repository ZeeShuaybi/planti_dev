defmodule VuePhoenixWeb.Router do
  use VuePhoenixWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", VuePhoenixWeb do
    pipe_through :api

    get "/all-plants/user/:user", PageController, :get_all_plants
    post "/save-groups", PageController, :save_groups
  end

  scope "/", VuePhoenixWeb do
    pipe_through :browser

    get "/*path", PageController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", VuePhoenixWeb do
  #   pipe_through :api
  # end
end
