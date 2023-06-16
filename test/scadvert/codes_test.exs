defmodule Scadvert.CodesTest do
  use Scadvert.DataCase

  alias Scadvert.Codes

  describe "codes" do
    alias Scadvert.Codes.Code

    import Scadvert.CodesFixtures

    @invalid_attrs %{active: nil, description: nil, name: nil}

    test "list_codes/0 returns all codes" do
      code = code_fixture()
      assert Codes.list_codes() == [code]
    end

    test "get_code!/1 returns the code with given id" do
      code = code_fixture()
      assert Codes.get_code!(code.id) == code
    end

    test "create_code/1 with valid data creates a code" do
      valid_attrs = %{active: "some active", description: "some description", name: 42}

      assert {:ok, %Code{} = code} = Codes.create_code(valid_attrs)
      assert code.active == "some active"
      assert code.description == "some description"
      assert code.name == 42
    end

    test "create_code/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Codes.create_code(@invalid_attrs)
    end

    test "update_code/2 with valid data updates the code" do
      code = code_fixture()

      update_attrs = %{
        active: "some updated active",
        description: "some updated description",
        name: 43
      }

      assert {:ok, %Code{} = code} = Codes.update_code(code, update_attrs)
      assert code.active == "some updated active"
      assert code.description == "some updated description"
      assert code.name == 43
    end

    test "update_code/2 with invalid data returns error changeset" do
      code = code_fixture()
      assert {:error, %Ecto.Changeset{}} = Codes.update_code(code, @invalid_attrs)
      assert code == Codes.get_code!(code.id)
    end

    test "delete_code/1 deletes the code" do
      code = code_fixture()
      assert {:ok, %Code{}} = Codes.delete_code(code)
      assert_raise Ecto.NoResultsError, fn -> Codes.get_code!(code.id) end
    end

    test "change_code/1 returns a code changeset" do
      code = code_fixture()
      assert %Ecto.Changeset{} = Codes.change_code(code)
    end
  end
end
