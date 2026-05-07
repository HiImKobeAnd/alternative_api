defmodule AlternativeApiWeb.PageController do
  use AlternativeApiWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
