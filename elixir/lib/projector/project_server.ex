defmodule Projector.ProjectServer do
  @moduledoc """
  Project Server. Uses [ETS](https://www.erlang.org/doc/man/ets.html) for
  in-memory KV store.

  Reads are concurrent and writes are serial.
  """
  use GenServer

  alias Projector.Project

  @aliases_table :aliases
  @projects_table :projects

  # ----------------------------------------------------------------------------
  # Public API
  # ----------------------------------------------------------------------------

  @doc """
  Start the Projector process and load the config.
  """
  @spec start_link(String.t()) :: GenServer.on_start()
  def start_link(config_path) do
    GenServer.start_link(__MODULE__, config_path, name: __MODULE__)
  end

  @doc """
  Get the value of a `key` for the `path`.

  Checks path first, and then checks for an alias. This allows you to use
  another project's config as a default, but override specific keys.

  Also recursively checks path aliases, in case you have aliases of aliases.
  """
  @spec get_value(String.t(), String.t()) :: String.t() | nil
  def get_value(path, key) do
    case lookup_project(path, key) do
      nil ->
        path_alias = get_alias(path)
        path_alias && get_value(path_alias, key)

      value ->
        value
    end
  end

  @doc """
  Add a value to the path and key. Replaces values, if exists.
  """
  @spec add_value(String.t(), String.t(), String.t()) :: :ok
  def add_value(path, key, value) do
    GenServer.cast(__MODULE__, {:add_value, path, key, value})
  end

  @doc """
  Remove a value for the path and key.
  """
  @spec remove_value(String.t(), String.t()) :: :ok
  def remove_value(path, key) do
    GenServer.cast(__MODULE__, {:remove_value, path, key})
  end

  @doc """
  Get the alias of the path if it exists.
  """
  @spec get_alias(String.t()) :: String.t() | nil
  def get_alias(path) do
    lookup_alias(path)
  end

  @doc """
  Add an alias. Replaces aliases, if exists.
  """
  @spec add_alias(String.t(), String.t()) :: :ok | {:error, :path_not_found}
  def add_alias(path_from, path_to) do
    GenServer.call(__MODULE__, {:add_alias, path_from, path_to})
  end

  @doc """
  Remove an alias.
  """
  @spec remove_alias(String.t()) :: :ok
  def remove_alias(path_from) do
    GenServer.cast(__MODULE__, {:remove_alias, path_from})
  end

  # ----------------------------------------------------------------------------
  # GenServer Callbacks
  # ----------------------------------------------------------------------------

  @impl GenServer
  def init(config_path) do
    aliases = :ets.new(@aliases_table, [:named_table, read_concurrency: true])
    projects = :ets.new(@projects_table, [:named_table, read_concurrency: true])

    project = Project.load(config_path)
    load_ets_projects(projects, project.projects)
    load_ets_aliases(aliases, project.aliases)

    {:ok, {aliases, projects}}
  end

  @impl GenServer
  def handle_cast({:add_value, path, key, value}, {aliases, projects}) do
    :ets.insert(projects, {{path, key}, value})
    {:noreply, {aliases, projects}}
  end

  def handle_cast({:remove_value, path, key}, {aliases, projects}) do
    :ets.delete(projects, {path, key})
    {:noreply, {aliases, projects}}
  end

  def handle_cast({:remove_alias, path_from}, {aliases, projects}) do
    :ets.delete(aliases, path_from)
    {:noreply, {aliases, projects}}
  end

  @impl GenServer
  def handle_call({:add_alias, path_from, path_to}, _from, {aliases, projects}) do
    if has_path?(path_to) do
      :ets.insert(aliases, {path_from, path_to})
      {:reply, :ok, {aliases, projects}}
    else
      {:reply, {:error, :path_not_found}, {aliases, projects}}
    end
  end

  # ----------------------------------------------------------------------------
  # Internal API
  # ----------------------------------------------------------------------------

  defp lookup_project(path, key) do
    case :ets.lookup(@projects_table, {path, key}) do
      [{{_path, _key}, value}] -> value
      _ -> nil
    end
  end

  defp lookup_alias(path) do
    case :ets.lookup(@aliases_table, path) do
      [{^path, path_alias}] -> path_alias
      _ -> nil
    end
  end

  defp has_path?(path) do
    case :ets.match(@projects_table, {{path, '_'}, '_'}, 1) do
      {[[{{^path, _}, _}]], _} -> true
      _ -> false
    end
  end

  defp load_ets_projects(table, projects) do
    for {path, config} <- projects, {key, value} <- config do
      :ets.insert(table, {{path, key}, value})
    end
  end

  defp load_ets_aliases(table, aliases) do
    :ets.insert(table, Map.to_list(aliases))
  end
end
