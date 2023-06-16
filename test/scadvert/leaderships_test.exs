defmodule Scadvert.LeadershipsTest do
  use Scadvert.DataCase

  alias Scadvert.Leaderships

  describe "leaderships" do
    alias Scadvert.Leaderships.Leadership

    import Scadvert.LeadershipsFixtures

    @invalid_attrs %{code: nil, description: nil, name: nil, status: nil}

    test "list_leaderships/0 returns all leaderships" do
      leadership = leadership_fixture()
      assert Leaderships.list_leaderships() == [leadership]
    end

    test "get_leadership!/1 returns the leadership with given id" do
      leadership = leadership_fixture()
      assert Leaderships.get_leadership!(leadership.id) == leadership
    end

    test "create_leadership/1 with valid data creates a leadership" do
      valid_attrs = %{code: 42, description: "some description", name: "some name", status: "some status"}

      assert {:ok, %Leadership{} = leadership} = Leaderships.create_leadership(valid_attrs)
      assert leadership.code == 42
      assert leadership.description == "some description"
      assert leadership.name == "some name"
      assert leadership.status == "some status"
    end

    test "create_leadership/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Leaderships.create_leadership(@invalid_attrs)
    end

    test "update_leadership/2 with valid data updates the leadership" do
      leadership = leadership_fixture()
      update_attrs = %{code: 43, description: "some updated description", name: "some updated name", status: "some updated status"}

      assert {:ok, %Leadership{} = leadership} = Leaderships.update_leadership(leadership, update_attrs)
      assert leadership.code == 43
      assert leadership.description == "some updated description"
      assert leadership.name == "some updated name"
      assert leadership.status == "some updated status"
    end

    test "update_leadership/2 with invalid data returns error changeset" do
      leadership = leadership_fixture()
      assert {:error, %Ecto.Changeset{}} = Leaderships.update_leadership(leadership, @invalid_attrs)
      assert leadership == Leaderships.get_leadership!(leadership.id)
    end

    test "delete_leadership/1 deletes the leadership" do
      leadership = leadership_fixture()
      assert {:ok, %Leadership{}} = Leaderships.delete_leadership(leadership)
      assert_raise Ecto.NoResultsError, fn -> Leaderships.get_leadership!(leadership.id) end
    end

    test "change_leadership/1 returns a leadership changeset" do
      leadership = leadership_fixture()
      assert %Ecto.Changeset{} = Leaderships.change_leadership(leadership)
    end
  end
end
