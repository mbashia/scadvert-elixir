defmodule Scadvert.FeaturesTest do
  use Scadvert.DataCase

  alias Scadvert.Features

  describe "features" do
    alias Scadvert.Features.Feature

    import Scadvert.FeaturesFixtures

    @invalid_attrs %{code: nil, description: nil, name: nil, status: nil}

    test "list_features/0 returns all features" do
      feature = feature_fixture()
      assert Features.list_features() == [feature]
    end

    test "get_feature!/1 returns the feature with given id" do
      feature = feature_fixture()
      assert Features.get_feature!(feature.id) == feature
    end

    test "create_feature/1 with valid data creates a feature" do
      valid_attrs = %{
        code: 42,
        description: "some description",
        name: "some name",
        status: "some status"
      }

      assert {:ok, %Feature{} = feature} = Features.create_feature(valid_attrs)
      assert feature.code == 42
      assert feature.description == "some description"
      assert feature.name == "some name"
      assert feature.status == "some status"
    end

    test "create_feature/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Features.create_feature(@invalid_attrs)
    end

    test "update_feature/2 with valid data updates the feature" do
      feature = feature_fixture()

      update_attrs = %{
        code: 43,
        description: "some updated description",
        name: "some updated name",
        status: "some updated status"
      }

      assert {:ok, %Feature{} = feature} = Features.update_feature(feature, update_attrs)
      assert feature.code == 43
      assert feature.description == "some updated description"
      assert feature.name == "some updated name"
      assert feature.status == "some updated status"
    end

    test "update_feature/2 with invalid data returns error changeset" do
      feature = feature_fixture()
      assert {:error, %Ecto.Changeset{}} = Features.update_feature(feature, @invalid_attrs)
      assert feature == Features.get_feature!(feature.id)
    end

    test "delete_feature/1 deletes the feature" do
      feature = feature_fixture()
      assert {:ok, %Feature{}} = Features.delete_feature(feature)
      assert_raise Ecto.NoResultsError, fn -> Features.get_feature!(feature.id) end
    end

    test "change_feature/1 returns a feature changeset" do
      feature = feature_fixture()
      assert %Ecto.Changeset{} = Features.change_feature(feature)
    end
  end
end
