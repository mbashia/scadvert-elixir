defmodule Scadvert.Codes do
  @moduledoc """
  The Codes context.
  """

  import Ecto.Query, warn: false
  alias Scadvert.Repo

  alias Scadvert.Codes.Code

  @doc """
  Returns the list of codes.

  ## Examples

      iex> list_codes()
      [%Code{}, ...]

  """
  def count_codes do
    Repo.all(Code)
    |> Enum.count()
  end

  def list_all_codes do
    Repo.all(Code)
  end

  @doc """
  Gets a single code.

  Raises `Ecto.NoResultsError` if the Code does not exist.

  ## Examples

      iex> get_code!(123)
      %Code{}

      iex> get_code!(456)
      ** (Ecto.NoResultsError)

  """

  # def get_code!(id), do: Repo.get!(Code, id)

  def get_code!(id) do
    Repo.get!(Code, id)
    |> Repo.preload(:features)
    |> Repo.preload(:facilitys)
    |> Repo.preload(:images)
    |> Repo.preload(:videos)
    |> Repo.preload(:leaderships)
    |> Repo.preload(:headers)
  end

  @doc """
  Creates a code.

  ## Examples

      iex> create_code(%{field: value})
      {:ok, %Code{}}

      iex> create_code(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_code(attrs \\ %{}) do
    %Code{}
    |> Code.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a code.

  ## Examples

      iex> update_code(code, %{field: new_value})
      {:ok, %Code{}}

      iex> update_code(code, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_code(%Code{} = code, attrs) do
    code
    |> Code.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a code.

  ## Examples

      iex> delete_code(code)
      {:ok, %Code{}}

      iex> delete_code(code)
      {:error, %Ecto.Changeset{}}

  """
  def delete_code(%Code{} = code) do
    Repo.delete(code)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking code changes.

  ## Examples

      iex> change_code(code)
      %Ecto.Changeset{data: %Code{}}

  """
  def change_code(%Code{} = code, attrs \\ %{}) do
    Code.changeset(code, attrs)
  end

  def list_codes_by_user_id(conn) do
    user_id = conn.assigns.current_user.id
    query = from(c in Code, where: c.user_id == ^user_id)
  end

  def list_code_by_name(id) do
    Repo.one(from c in Code, where: c.name == ^id)
    |> Repo.preload(:features)
    |> Repo.preload(:facilitys)
    |> Repo.preload(:images)
    |> Repo.preload(:videos)
    |> Repo.preload(:leaderships)
    |> Repo.preload(:headers)
  end

  def search_params(conn, params) do
    user = conn.assigns.current_user

    params =
      cond do
        params == "active" ->
          "true"

        params == "inactive" ->
          "false"

        true ->
          params
      end

    if user.role == "admin" do
      query =
        from(c in Code,
          where:
            fragment("? LIKE ?", c.name, ^"%#{params}%") or
              fragment("? LIKE ?", c.description, ^"%#{params}%") or
              fragment("? LIKE ?", c.active, ^"%#{params}%")
        )

      query
    else
      query =
        from(c in Code,
          where:
            fragment("? LIKE ?", c.name, ^"%#{params}%") or
              fragment("? LIKE ?", c.description, ^"%#{params}%") or
              (fragment("? LIKE ?", c.active, ^"%#{params}%") and c.user_id == ^user.id)
        )

      query
    end
  end
end
