defmodule Scadvert.Functions do
  import Ecto.Query
  alias Scadvert.Repo
  import Ecto.Query, warn: false
  alias Scadvert.Codes.Code

  
  def list_codes(conn)do
    user_id = conn.assigns.current_user.id
    Repo.all(from p in Code, where: p.user_id == ^user_id, select: {p.name, p.id})

    end
end
