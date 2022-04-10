defmodule Projector.ProjectServer do
  @moduledoc """
  Project Server.
  """
  use GenServer

  alias Projector.Project

  ## Public API

  @doc """
  Start the Projector process and load the config.
  """
  @spec start_link(keyword()) :: GenServer.on_start()
  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  @doc """
  Get the value of a `key` for the `path`.
  """
  @spec get_value(String.t(), String.t()) :: String.t() | nil
  def get_value(path, key) do
    GenServer.call(__MODULE__, {:get_value, path, key})
  end

  @doc """
  Get the value of a `key` for the `pwd`.
  """
  @spec get_value(String.t()) :: String.t() | nil
  def get_value(key) do
    GenServer.call(__MODULE__, {:get_value, key})
  end

  ## GenServer Callbacks

  @impl GenServer
  def init(opts) do
    config_path = Keyword.fetch!(opts, :config_path)
    pwd = Keyword.fetch!(opts, :pwd)

    state = %{
      config_path: config_path,
      pwd: pwd,
      project: Project.load(config_path)
    }

    {:ok, state}
  end

  @impl GenServer
  def handle_call({:get_value, path, key}, _from, state) do
    value = Project.get_value(state.project, path, key)
    {:reply, value, state}
  end

  def handle_call({:get_value, key}, _from, state) do
    value = Project.get_value(state.project, state.pwd, key)
    {:reply, value, state}
  end
end
