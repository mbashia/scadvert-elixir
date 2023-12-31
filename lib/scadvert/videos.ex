defmodule Scadvert.Videos do
  @moduledoc """
  The Videos context.
  """

  import Ecto.Query, warn: false
  alias Scadvert.Repo

  alias Scadvert.Videos.Video

  @doc """
  Returns the list of videos.

  ## Examples

      iex> list_videos()
      [%Video{}, ...]

  """
  def count_videos do
    Repo.all(Video)
    |> Enum.count()

    # |> Repo.preload(:codes)
  end

  def list_all_videos do
    # Repo.all(Video)
    # |> Repo.preload(:codes)

    from(v in Video, select: v, preload: [:codes])
  end

  @doc """
  Gets a single video.

  Raises `Ecto.NoResultsError` if the Video does not exist.

  ## Examples

      iex> get_video!(123)
      %Video{}

      iex> get_video!(456)
      ** (Ecto.NoResultsError)

  """
  def get_video!(id),
    do:
      Repo.get!(Video, id)
      |> Repo.preload(:codes)

  @doc """
  Creates a video.

  ## Examples

      iex> create_video(%{field: value})
      {:ok, %Video{}}

      iex> create_video(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_video(attrs \\ %{}) do
    %Video{}
    |> Video.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a video.

  ## Examples

      iex> update_video(video, %{field: new_value})
      {:ok, %Video{}}

      iex> update_video(video, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_video(%Video{} = video, attrs) do
    video
    |> Video.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a video.

  ## Examples

      iex> delete_video(video)
      {:ok, %Video{}}

      iex> delete_video(video)
      {:error, %Ecto.Changeset{}}

  """
  def delete_video(%Video{} = video) do
    Repo.delete(video)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking video changes.

  ## Examples

      iex> change_video(video)
      %Ecto.Changeset{data: %Video{}}

  """
  def change_video(%Video{} = video, attrs \\ %{}) do
    Video.changeset(video, attrs)
  end

  def list_videos_by_user_id(conn) do
    user_id = conn.assigns.current_user.id

    # Repo.all(from v in Video, where: v.user_id == ^user_id)
    # |> Repo.preload(:codes)
    from(v in Video, where: v.user_id == ^user_id, preload: [:codes])
  end
end
