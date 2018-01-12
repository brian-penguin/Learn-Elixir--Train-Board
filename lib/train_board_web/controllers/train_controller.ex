defmodule TrainBoardWeb.TrainController do
  use TrainBoardWeb, :controller

  alias TrainBoard.Schedules
  alias TrainBoard.Schedules.Train

  def index(conn, %{"origin" => origin}) do
    trains = Schedules.list_trains(origin)
    render(conn, "index.html", trains: trains, origin: origin)
  end

  def index(conn, _params) do
    # default to north station
    origin = "North Station"
    trains = Schedules.list_trains(origin)
    render(conn, "index.html", trains: trains, origin: origin)
  end
end
