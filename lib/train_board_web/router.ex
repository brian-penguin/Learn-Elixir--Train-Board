defmodule TrainBoardWeb.Router do
  use TrainBoardWeb, :router

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

  scope "/", TrainBoardWeb do
    pipe_through :browser # Use the default browser stack

    get "/", TrainController, :index
    get "/trains", TrainController, :index
  end

  # Other scopes may use custom stacks.
  # scope "/api", TrainBoardWeb do
  #   pipe_through :api
  # end
end
