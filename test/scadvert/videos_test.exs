defmodule Scadvert.VideosTest do
  use Scadvert.DataCase

  alias Scadvert.Videos

  describe "videos" do
    alias Scadvert.Videos.Video

    import Scadvert.VideosFixtures

    @invalid_attrs %{code: nil, description: nil, name: nil, status: nil}

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Videos.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Videos.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      valid_attrs = %{
        code: 42,
        description: "some description",
        name: "some name",
        status: "some status"
      }

      assert {:ok, %Video{} = video} = Videos.create_video(valid_attrs)
      assert video.code == 42
      assert video.description == "some description"
      assert video.name == "some name"
      assert video.status == "some status"
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Videos.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()

      update_attrs = %{
        code: 43,
        description: "some updated description",
        name: "some updated name",
        status: "some updated status"
      }

      assert {:ok, %Video{} = video} = Videos.update_video(video, update_attrs)
      assert video.code == 43
      assert video.description == "some updated description"
      assert video.name == "some updated name"
      assert video.status == "some updated status"
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Videos.update_video(video, @invalid_attrs)
      assert video == Videos.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Videos.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Videos.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Videos.change_video(video)
    end
  end
end
