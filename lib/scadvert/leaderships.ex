defmodule Scadvert.Leaderships do
  @moduledoc """
  The Leaderships context.
  """

  import Ecto.Query, warn: false
  alias Scadvert.Repo

  alias Scadvert.Leaderships.Leadership

  @doc """
  Returns the list of leaderships.

  ## Examples

      iex> list_leaderships()
      [%Leadership{}, ...]

  """
  def count_leaderships do
    Repo.all(Leadership)
    |> Enum.count()

  end
  def list_all_leaderships do
    Repo.all(Leadership)
    |> Repo.preload(:codes)

  end

  @doc """
  Gets a single leadership.

  Raises `Ecto.NoResultsError` if the Leadership does not exist.

  ## Examples

      iex> get_leadership!(123)
      %Leadership{}

      iex> get_leadership!(456)
      ** (Ecto.NoResultsError)

  """
  def get_leadership!(id),
    do:
      Repo.get!(Leadership, id)
      |> Repo.preload(:codes)

  @doc """
  Creates a leadership.

  ## Examples

      iex> create_leadership(%{field: value})
      {:ok, %Leadership{}}

      iex> create_leadership(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_leadership(attrs \\ %{}) do
    %Leadership{}
    |> Leadership.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a leadership.

  ## Examples

      iex> update_leadership(leadership, %{field: new_value})
      {:ok, %Leadership{}}

      iex> update_leadership(leadership, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_leadership(%Leadership{} = leadership, attrs) do
    leadership
    |> Leadership.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a leadership.

  ## Examples

      iex> delete_leadership(leadership)
      {:ok, %Leadership{}}

      iex> delete_leadership(leadership)
      {:error, %Ecto.Changeset{}}

  """
  def delete_leadership(%Leadership{} = leadership) do
    Repo.delete(leadership)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking leadership changes.

  ## Examples

      iex> change_leadership(leadership)
      %Ecto.Changeset{data: %Leadership{}}

  """
  def change_leadership(%Leadership{} = leadership, attrs \\ %{}) do
    Leadership.changeset(leadership, attrs)
  end

  def list_leaderships_by_user_id(conn) do
    user_id = conn.assigns.current_user.id

    Repo.all(from l in Leadership, where: l.user_id == ^user_id)
    |> Repo.preload(:codes)
  end
end
