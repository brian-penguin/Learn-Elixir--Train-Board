defmodule TrainBoard.SchedulesTest do
  use TrainBoard.DataCase

  alias TrainBoard.Schedules

  describe "trains" do
    alias TrainBoard.Schedules.Train

    @valid_attrs %{destination: "some destination", lateness: 42, origin: "some origin", scheduled_time: ~N[2010-04-17 14:00:00.000000], status: "some status", track: 42, trip: "some trip"}
    @update_attrs %{destination: "some updated destination", lateness: 43, origin: "some updated origin", scheduled_time: ~N[2011-05-18 15:01:01.000000], status: "some updated status", track: 43, trip: "some updated trip"}
    @invalid_attrs %{destination: nil, lateness: nil, origin: nil, scheduled_time: nil, status: nil, track: nil, trip: nil}

    def train_fixture(attrs \\ %{}) do
      {:ok, train} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Schedules.create_train()

      train
    end

    test "list_trains/0 returns all trains" do
      train = train_fixture()
      assert Schedules.list_trains() == [train]
    end

    test "get_train!/1 returns the train with given id" do
      train = train_fixture()
      assert Schedules.get_train!(train.id) == train
    end

    test "create_train/1 with valid data creates a train" do
      assert {:ok, %Train{} = train} = Schedules.create_train(@valid_attrs)
      assert train.destination == "some destination"
      assert train.lateness == 42
      assert train.origin == "some origin"
      assert train.scheduled_time == ~N[2010-04-17 14:00:00.000000]
      assert train.status == "some status"
      assert train.track == 42
      assert train.trip == "some trip"
    end

    test "create_train/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Schedules.create_train(@invalid_attrs)
    end

    test "update_train/2 with valid data updates the train" do
      train = train_fixture()
      assert {:ok, train} = Schedules.update_train(train, @update_attrs)
      assert %Train{} = train
      assert train.destination == "some updated destination"
      assert train.lateness == 43
      assert train.origin == "some updated origin"
      assert train.scheduled_time == ~N[2011-05-18 15:01:01.000000]
      assert train.status == "some updated status"
      assert train.track == 43
      assert train.trip == "some updated trip"
    end

    test "update_train/2 with invalid data returns error changeset" do
      train = train_fixture()
      assert {:error, %Ecto.Changeset{}} = Schedules.update_train(train, @invalid_attrs)
      assert train == Schedules.get_train!(train.id)
    end

    test "delete_train/1 deletes the train" do
      train = train_fixture()
      assert {:ok, %Train{}} = Schedules.delete_train(train)
      assert_raise Ecto.NoResultsError, fn -> Schedules.get_train!(train.id) end
    end

    test "change_train/1 returns a train changeset" do
      train = train_fixture()
      assert %Ecto.Changeset{} = Schedules.change_train(train)
    end
  end
end
