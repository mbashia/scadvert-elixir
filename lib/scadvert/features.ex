defmodule Scadvert.Features do
  @moduledoc """
  The Features context.
  """

  import Ecto.Query, warn: false
  alias Scadvert.Repo

  alias Scadvert.Features.Feature

  @doc """
  Returns the list of features.

  ## Examples

      iex> list_features()
      [%Feature{}, ...]

  """
  def count_features do
    Repo.all(Feature)
    |> Enum.count()

  end

  def list_all_features do
    Repo.all(Features)
    |> Repo.preload(:codes)

  end

  @doc """
  Gets a single feature.

  Raises `Ecto.NoResultsError` if the Feature does not exist.

  ## Examples

      iex> get_feature!(123)
      %Feature{}

      iex> get_feature!(456)
      ** (Ecto.NoResultsError)

  """
  def get_feature!(id),
    do:
      Repo.get!(Feature, id)
      |> Repo.preload(:codes)

  @doc """
  Creates a feature.

  ## Examples

      iex> create_feature(%{field: value})
      {:ok, %Feature{}}

      iex> create_feature(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_feature(attrs \\ %{}) do
    %Feature{}
    |> Feature.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a feature.

  ## Examples

      iex> update_feature(feature, %{field: new_value})
      {:ok, %Feature{}}

      iex> update_feature(feature, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_feature(%Feature{} = feature, attrs) do
    feature
    |> Feature.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a feature.

  ## Examples

      iex> delete_feature(feature)
      {:ok, %Feature{}}

      iex> delete_feature(feature)
      {:error, %Ecto.Changeset{}}

  """
  def delete_feature(%Feature{} = feature) do
    Repo.delete(feature)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking feature changes.

  ## Examples

      iex> change_feature(feature)
      %Ecto.Changeset{data: %Feature{}}

  """
  def change_feature(%Feature{} = feature, attrs \\ %{}) do
    Feature.changeset(feature, attrs)
  end

  def list_features_by_user_id(conn) do
    user_id = conn.assigns.current_user.id

    Repo.all(from t in Feature, where: t.user_id == ^user_id)
    |> Repo.preload(:codes)
  end
end
