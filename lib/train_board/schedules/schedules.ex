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
    Repo.all(Train, order_by: :scheduled_time)
  end

  @doc """
  Delete all the Trains!
  """
  def clear_trains do
    Repo.delete_all(Train)
  end

  def create_trains do
    Repo.transaction(fn ->
        File.stream!("depatures.csv")
        # skip headers
        |> Stream.drop(1)
        # gives a stream of row tuples in row 2 (we need to take the second value (the fields and pass to store_it))
        |> CSV.decode(headers: [:timestamp, :origin, :trip, :destination, :scheduled_time, :lateness, :track, :status])
        |> Enum.each(&store_it/1)
    end)
  end

  # Copied Temporarily
  def store_it({:ok, attrs}) do
    train_attrs = Map.merge(attrs, %{scheduled_time: convert_to_naive_datetime(attrs.scheduled_time) })
    changeset = Train.changeset(%Train{}, train_attrs)
    Repo.insert!(changeset)
  end

  # We are trusting that the source will always have a valid value
  def convert_to_naive_datetime(epoch_string) do
    epoch_string
    |> String.to_integer
    |> DateTime.from_unix(:seconds)
    |> elem(1)
    |> DateTime.to_naive
  end
end
