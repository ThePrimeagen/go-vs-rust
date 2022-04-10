defmodule ProjectorWeb do
  @moduledoc """
  Documentation for `Projector.Web`.
  """

  @behaviour Plug

  import Plug.Conn

  @doc """
  A required callback that we don't need. The processed `opts` returned here
  gets passed to the `call/2` function as the second argument.
  """
  @impl Plug
  def init(opts), do: opts

  @doc """
  Handle the shiz.
  """
  @impl Plug
  def call(conn, _opts) do
    send_resp(conn, 200, "Hello world!")
  end
end
