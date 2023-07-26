defmodule Scadvert.Repo do
  use Ecto.Repo,
    otp_app: :scadvert,
    adapter: Ecto.Adapters.MyXQL
    use Scrivener, page_size: 1

end
