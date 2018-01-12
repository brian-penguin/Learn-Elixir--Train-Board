defmodule TrainBoard.Schedules do
  @moduledoc """
  The Schedules context.
  """

  @refresh_file_url "http://developer.mbta.com/lib/gtrtfs/Departures.csv"

  import Ecto.Query, warn: false
  alias TrainBoard.Repo

  alias TrainBoard.Schedules.Train

  @doc """
  Returns the list of trains.

  ## Examples

      iex> list_trains()
      [%Train{}, ...]

  """
  def list_trains(origin) do
    Train |> where(origin: ^origin) |> order_by(:scheduled_time) |> Repo.all()
  end

  def list_trains do
    Train |> order_by(:scheduled_time) |> Repo.all()
  end

  @doc """
  Delete all the Trains!
  """
  def clear_trains do
    Repo.delete_all(Train)
  end

  @doc """
  given a csv file, parse the file, and create all the trains from the file
  """
  def create_trains_from_file(file_path) do
    File.stream!(file_path)
    # skip headers
    |> Stream.drop(1)
    # gives a stream of row tuples in row 2 (we need to take the second value (the fields and pass to store_it))
    |> CSV.decode(headers: [:timestamp, :origin, :trip, :destination, :scheduled_time, :lateness, :track, :status])
    |> Enum.each(&store_train/1)
  end

  @doc """
  convert the csv version of attrs and save to db
  """
  def store_train({_, attrs}) do
    train_attrs = Map.merge(attrs, %{scheduled_time: TimeUtil.convert_to_naive_datetime(attrs.scheduled_time) })
    changeset = Train.changeset(%Train{}, train_attrs)
    Repo.insert!(changeset)
  end

  @doc """
  If there's a new file successfully downloaded then clear the trains and create them from file
  - Otherwise log the error
  """
  def clear_and_reset_trains do
    case fetch_new_trains_file do
      {:ok, _, file_path} -> 
        TrainBoard.Repo.transaction(fn ->
          clear_trains
          create_trains_from_file(file_path)
        end)
      {:error, reason} ->
        IO.puts reason
    end
  end

  @doc """
  Request and save the trains schedule csv to a Temp file
  """
  def fetch_new_trains_file do
    case HTTPoison.get(@refresh_file_url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        # Do something with the file!
        {:ok, file, file_path} = Temp.open "new_departures"
        IO.write(file, body)
        {:ok, file, file_path}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end
end
