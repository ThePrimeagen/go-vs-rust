defmodule Projector.Project do
  @moduledoc """
  Project struct and functions.
  """

  alias __MODULE__

  defstruct aliases: %{}, projects: %{}

  @type path :: String.t()

  @type key :: String.t()

  @type value :: String.t()

  @type t :: %Project{
          aliases: %{optional(path()) => path()},
          projects: %{
            optional(path()) => %{
              optional(key()) => value()
            }
          }
        }

  @doc """
  Create a new `Project` struct from a map.
  """
  @spec new!(map()) :: t()
  def new!(attrs) when is_map(attrs) do
    struct!(Project, attrs)
  end

  @doc """
  Load the project from a file, if it exists. Returns an empty `%Project{}` if not.
  """
  @spec load(path()) :: t()
  def load(config_path) do
    if File.exists?(config_path) do
      config_path
      |> File.read!()
      |> Jason.decode!()
      |> new!()
    else
      %Project{}
    end
  end

  @doc """
  Get the value from the project for a specific path and key.
  """
  @spec get_value(t(), path(), key()) :: value() | nil
  def get_value(%Project{} = project, path, key) do
    [root | paths] = Path.split(path)

    {_path, value} =
      Enum.reduce(paths, {root, nil}, fn dir, {parent, value} ->
        current_path = Path.join(parent, dir)
        current_path = Map.get(project.aliases, current_path, current_path)

        case get_in(project.projects, [current_path, key]) do
          nil -> {current_path, value}
          new_value -> {current_path, new_value}
        end
      end)

    value
  end

  @doc """
  Put the value of the key in the project's path.
  """
  @spec put_value(t(), path(), key(), value()) :: t()
  def put_value(%Project{} = project, path, key, value) do
    %Project{project | projects: put_in(project.projects, [path, key], value)}
  end

  @doc """
  Delete the key/value pair of the key in the project's path.
  """
  @spec delete(t(), path(), key()) :: t()
  def delete(%Project{} = project, path, key) do
    %Project{project | projects: pop_in(project.projects, [path, key]) |> elem(1)}
  end

  @doc """
  Delete the project path.
  """
  @spec delete(t(), path()) :: t()
  def delete(%Project{} = project, path) do
    %Project{project | projects: Map.delete(project.projects, path)}
  end

  @doc """
  Put the alias.
  """
  @spec put_alias(t(), path(), path()) :: t()
  def put_alias(%Project{} = project, from_path, to_path) do
    %Project{project | aliases: Map.put(project.aliases, from_path, to_path)}
  end

  @doc """
  Put the alias.
  """
  @spec delete_alias(t(), path()) :: t()
  def delete_alias(%Project{} = project, from_path) do
    %Project{project | aliases: Map.delete(project.aliases, from_path)}
  end
end
