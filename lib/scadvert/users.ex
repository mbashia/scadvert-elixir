defmodule Scadvert.Users do
  import Ecto.Query, warn: false

  alias Scadvert.Accounts.User

  def change_user(%User{} = user, attrs \\ %{}) do
    User.change_user_changeset(user, attrs)
  end
end
