defmodule TrainBoard.Repo.Migrations.CreateTrains do
  use Ecto.Migration

  def change do
    create table(:trains) do
      add :destination, :string
      add :lateness, :integer
      add :origin, :string
      add :scheduled_time, :naive_datetime
      add :status, :string
      add :track, :integer
      add :trip, :string

      timestamps()
    end

  end
end
