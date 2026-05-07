defmodule AlternativeApi.Repo do
  use Ecto.Repo,
    otp_app: :alternative_api,
    adapter: Ecto.Adapters.SQLite3
end
