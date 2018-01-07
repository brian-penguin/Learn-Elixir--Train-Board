# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TrainBoard.Repo.insert!(%TrainBoard.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias TrainBoard.Repo
alias TrainBoard.Schedules.Train

# Repo.insert!(
#   %Train{
#     origin: "mars",
#     trip: "To the Moon",
#     destination: "yes",
#     scheduled_time: DateTime.utc_now,
#     lateness: 0,
#     status: "nice"
#   }
# )

defmodule TrainBoard.Seeds do
  def store_it({_, attrs}) do
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

# Possible improvement here => create a collection of changesets and use a transaction
File.stream!("depatures.csv")
|> Stream.drop(1) # skip headers
# gives a stream of row tuples in row 2 (we need to take the second value (the fields and pass to store_it))
|> CSV.decode(headers: [:timestamp, :origin, :trip, :destination, :scheduled_time, :lateness, :track, :status])
|> Enum.each(&TrainBoard.Seeds.store_it/1)
