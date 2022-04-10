defmodule ProjectorWeb.Router do
  use Plug.Router

  plug(Plug.Logger)
  plug(:match)
  plug(:dispatch)

  get("/hello", to: ProjectorWeb)

  match _ do
    send_resp(conn, 404, "!found")
  end
end
