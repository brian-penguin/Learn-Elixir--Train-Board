defmodule TrainBoard.Schedules.Train do
  use Ecto.Schema
  import Ecto.Changeset
  alias TrainBoard.Schedules.Train

  schema "trains" do
    field :destination, :string
    field :lateness, :integer
    field :origin, :string
    field :scheduled_time, :naive_datetime
    field :status, :string
    field :track, :integer
    field :trip, :string

    timestamps()
  end

  @doc false
  def changeset(%Train{} = train, attrs) do
    train
    |> cast(attrs, [:destination, :lateness, :origin, :scheduled_time, :status, :track, :trip])
    |> validate_required([:destination, :lateness, :origin, :scheduled_time, :status, :trip])
  end
end
