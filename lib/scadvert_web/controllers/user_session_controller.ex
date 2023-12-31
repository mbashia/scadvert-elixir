defmodule ScadvertWeb.UserSessionController do
  use ScadvertWeb, :controller

  alias Scadvert.Accounts
  alias ScadvertWeb.UserAuth

  plug :put_layout, "login_registration.html"

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"user" => user_params}) do
    %{"email" => email, "password" => password} = user_params

    case Accounts.get_user_by_email_and_password(email, password) do
      {:ok, user} ->
        UserAuth.log_in_user(conn, user, user_params)

      _ ->
        # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
        render(conn, "new.html", error_message: "Invalid email or password/suspended account")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> UserAuth.log_out_user()
  end
end
