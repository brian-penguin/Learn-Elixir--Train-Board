defmodule TrainBoardWeb.TrainController do
  use TrainBoardWeb, :controller

  alias TrainBoard.Schedules
  alias TrainBoard.Schedules.Train

  def index(conn, _params) do
    trains = Schedules.list_trains()
    render(conn, "index.html", trains: trains)
  end
end
