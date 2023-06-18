defmodule Scadvert.Functions do
  import Ecto.Query
  alias Scadvert.Repo
  import Ecto.Query, warn: false


  alias Scadvert.Codes.Code
  def list_codes(conn, _params)do
    user_id = conn.assigns.current_user.id
    codes = Repo.all(from p in Code, where: p.user_id == ^user_id)

    end
end
