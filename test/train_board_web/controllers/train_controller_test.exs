defmodule TrainBoardWeb.TrainControllerTest do
  use TrainBoardWeb.ConnCase

  alias TrainBoard.Schedules

  @create_attrs %{destination: "some destination", lateness: 42, origin: "some origin", scheduled_time: ~N[2010-04-17 14:00:00.000000], status: "some status", track: 42, trip: "some trip"}
  @update_attrs %{destination: "some updated destination", lateness: 43, origin: "some updated origin", scheduled_time: ~N[2011-05-18 15:01:01.000000], status: "some updated status", track: 43, trip: "some updated trip"}
  @invalid_attrs %{destination: nil, lateness: nil, origin: nil, scheduled_time: nil, status: nil, track: nil, trip: nil}

  def fixture(:train) do
    {:ok, train} = Schedules.create_train(@create_attrs)
    train
  end

  describe "index" do
    test "lists all trains", %{conn: conn} do
      conn = get conn, train_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing Trains"
    end
  end

  describe "new train" do
    test "renders form", %{conn: conn} do
      conn = get conn, train_path(conn, :new)
      assert html_response(conn, 200) =~ "New Train"
    end
  end

  describe "create train" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post conn, train_path(conn, :create), train: @create_attrs

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == train_path(conn, :show, id)

      conn = get conn, train_path(conn, :show, id)
      assert html_response(conn, 200) =~ "Show Train"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, train_path(conn, :create), train: @invalid_attrs
      assert html_response(conn, 200) =~ "New Train"
    end
  end

  describe "edit train" do
    setup [:create_train]

    test "renders form for editing chosen train", %{conn: conn, train: train} do
      conn = get conn, train_path(conn, :edit, train)
      assert html_response(conn, 200) =~ "Edit Train"
    end
  end

  describe "update train" do
    setup [:create_train]

    test "redirects when data is valid", %{conn: conn, train: train} do
      conn = put conn, train_path(conn, :update, train), train: @update_attrs
      assert redirected_to(conn) == train_path(conn, :show, train)

      conn = get conn, train_path(conn, :show, train)
      assert html_response(conn, 200) =~ "some updated destination"
    end

    test "renders errors when data is invalid", %{conn: conn, train: train} do
      conn = put conn, train_path(conn, :update, train), train: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit Train"
    end
  end

  describe "delete train" do
    setup [:create_train]

    test "deletes chosen train", %{conn: conn, train: train} do
      conn = delete conn, train_path(conn, :delete, train)
      assert redirected_to(conn) == train_path(conn, :index)
      assert_error_sent 404, fn ->
        get conn, train_path(conn, :show, train)
      end
    end
  end

  defp create_train(_) do
    train = fixture(:train)
    {:ok, train: train}
  end
end
