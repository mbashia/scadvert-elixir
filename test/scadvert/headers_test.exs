defmodule Scadvert.HeadersTest do
  use Scadvert.DataCase

  alias Scadvert.Headers

  describe "headers" do
    alias Scadvert.Headers.Header

    import Scadvert.HeadersFixtures

    @invalid_attrs %{code: nil, description: nil, name: nil, status: nil}

    test "list_headers/0 returns all headers" do
      header = header_fixture()
      assert Headers.list_headers() == [header]
    end

    test "get_header!/1 returns the header with given id" do
      header = header_fixture()
      assert Headers.get_header!(header.id) == header
    end

    test "create_header/1 with valid data creates a header" do
      valid_attrs = %{
        code: 42,
        description: "some description",
        name: "some name",
        status: "some status"
      }

      assert {:ok, %Header{} = header} = Headers.create_header(valid_attrs)
      assert header.code == 42
      assert header.description == "some description"
      assert header.name == "some name"
      assert header.status == "some status"
    end

    test "create_header/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Headers.create_header(@invalid_attrs)
    end

    test "update_header/2 with valid data updates the header" do
      header = header_fixture()

      update_attrs = %{
        code: 43,
        description: "some updated description",
        name: "some updated name",
        status: "some updated status"
      }

      assert {:ok, %Header{} = header} = Headers.update_header(header, update_attrs)
      assert header.code == 43
      assert header.description == "some updated description"
      assert header.name == "some updated name"
      assert header.status == "some updated status"
    end

    test "update_header/2 with invalid data returns error changeset" do
      header = header_fixture()
      assert {:error, %Ecto.Changeset{}} = Headers.update_header(header, @invalid_attrs)
      assert header == Headers.get_header!(header.id)
    end

    test "delete_header/1 deletes the header" do
      header = header_fixture()
      assert {:ok, %Header{}} = Headers.delete_header(header)
      assert_raise Ecto.NoResultsError, fn -> Headers.get_header!(header.id) end
    end

    test "change_header/1 returns a header changeset" do
      header = header_fixture()
      assert %Ecto.Changeset{} = Headers.change_header(header)
    end
  end
end
