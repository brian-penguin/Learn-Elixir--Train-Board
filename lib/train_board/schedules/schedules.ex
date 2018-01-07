defmodule TrainBoard.Schedules do
  @moduledoc """
  The Schedules context.
  """

  import Ecto.Query, warn: false
  alias TrainBoard.Repo

  alias TrainBoard.Schedules.Train

  @doc """
  Returns the list of trains.

  ## Examples

      iex> list_trains()
      [%Train{}, ...]

  """
  def list_trains do
    Repo.all(Train)
  end
end
