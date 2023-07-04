defmodule Scadvert.Users do

alias Scadvert.Accounts.User



  def change_user(%User{} = user, attrs \\ %{})do
    User.change_user_changeset(user,attrs)

  end
  def change_feature(%Feature{} = feature, attrs \\ %{}) do
    Feature.changeset(feature, attrs)
  end

end
