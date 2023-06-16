defmodule Scadvert.FacilitysTest do
  use Scadvert.DataCase

  alias Scadvert.Facilitys

  describe "facilitys" do
    alias Scadvert.Facilitys.Facility

    import Scadvert.FacilitysFixtures

    @invalid_attrs %{active: nil, code: nil, description: nil, name: nil}

    test "list_facilitys/0 returns all facilitys" do
      facility = facility_fixture()
      assert Facilitys.list_facilitys() == [facility]
    end

    test "get_facility!/1 returns the facility with given id" do
      facility = facility_fixture()
      assert Facilitys.get_facility!(facility.id) == facility
    end

    test "create_facility/1 with valid data creates a facility" do
      valid_attrs = %{active: "some active", code: 42, description: "some description", name: "some name"}

      assert {:ok, %Facility{} = facility} = Facilitys.create_facility(valid_attrs)
      assert facility.active == "some active"
      assert facility.code == 42
      assert facility.description == "some description"
      assert facility.name == "some name"
    end

    test "create_facility/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Facilitys.create_facility(@invalid_attrs)
    end

    test "update_facility/2 with valid data updates the facility" do
      facility = facility_fixture()
      update_attrs = %{active: "some updated active", code: 43, description: "some updated description", name: "some updated name"}

      assert {:ok, %Facility{} = facility} = Facilitys.update_facility(facility, update_attrs)
      assert facility.active == "some updated active"
      assert facility.code == 43
      assert facility.description == "some updated description"
      assert facility.name == "some updated name"
    end

    test "update_facility/2 with invalid data returns error changeset" do
      facility = facility_fixture()
      assert {:error, %Ecto.Changeset{}} = Facilitys.update_facility(facility, @invalid_attrs)
      assert facility == Facilitys.get_facility!(facility.id)
    end

    test "delete_facility/1 deletes the facility" do
      facility = facility_fixture()
      assert {:ok, %Facility{}} = Facilitys.delete_facility(facility)
      assert_raise Ecto.NoResultsError, fn -> Facilitys.get_facility!(facility.id) end
    end

    test "change_facility/1 returns a facility changeset" do
      facility = facility_fixture()
      assert %Ecto.Changeset{} = Facilitys.change_facility(facility)
    end
  end
end
