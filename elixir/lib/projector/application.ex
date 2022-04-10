defmodule Projector.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  require Logger

  @impl true
  def start(_type, _args) do
    children = [
      {Plug.Cowboy, scheme: :http, plug: ProjectorWeb.Router, options: [port: 8080]}
      # Starts a worker by calling: Projector.Worker.start_link(arg)
      # {Projector.Worker, arg}
    ]

    Logger.info("[Application] starting web server at http://localhost:8080")

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Projector.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
