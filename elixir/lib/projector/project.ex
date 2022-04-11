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

  ## Example

      iex> new!(%{projects: %{"foo" => %{"bar" => "baz"}}})
      %Project{aliases: %{}, projects: %{"foo" => %{"bar" => "baz"}}}

      iex> new!()
      %Project{aliases: %{}, projects: %{}}

  """
  @spec new!(map()) :: t()
  def new!(attrs \\ %{}) when is_map(attrs) do
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
      new!()
    end
  end

  @doc """
  Get the value from the project for a specific path and key.

  ## Examples

      iex> project = new!(%{projects: %{"/foo" => %{"bar" => "baz"}}})
      iex> get_value(project, "/foo", "bar")
      "baz"

      iex> project = new!(%{aliases: %{"/fizz" => "/foo"}, projects: %{"/foo" => %{"bar" => "baz"}}})
      iex> get_value(project, "/fizz", "bar")
      "baz"

      iex> project = new!(%{projects: %{"/foo" => %{"bar" => "baz"}}})
      iex> get_value(project, "/foo", "banana")
      nil

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

  ## Examples

      iex> put_value(new!(), "/foo", "bar", "baz")
      %Project{projects: %{"/foo" => %{"bar" => "baz"}}}

      iex> project = %Project{projects: %{"/foo" => %{"bar" => "baz"}}}
      iex> put_value(project, "/foo", "bar", "banana")
      %Project{projects: %{"/foo" => %{"bar" => "banana"}}}

  """
  @spec put_value(t(), path(), key(), value()) :: t()
  def put_value(%Project{} = project, path, key, value) do
    %Project{
      project
      | projects: put_in(project.projects, Enum.map([path, key], &Access.key(&1, %{})), value)
    }
  end

  @doc """
  Delete the key/value pair of the key in the project's path.

  ## Example

      iex> project = %Project{projects: %{"/foo" => %{"bar" => "baz"}}}
      iex> delete(project, "/foo", "bar")
      %Project{projects: %{"/foo" => %{}}}

  """
  @spec delete(t(), path(), key()) :: t()
  def delete(%Project{} = project, path, key) do
    %Project{project | projects: pop_in(project.projects, [path, key]) |> elem(1)}
  end

  @doc """
  Delete the project path.

  ## Example

      iex> project = %Project{projects: %{"/foo" => %{"bar" => "baz"}}}
      iex> delete(project, "/foo")
      %Project{projects: %{}}

  """
  @spec delete(t(), path()) :: t()
  def delete(%Project{} = project, path) do
    %Project{project | projects: Map.delete(project.projects, path)}
  end

  @doc """
  Put the alias.

  ## Example

      iex> project = %Project{projects: %{"/foo" => %{"bar" => "baz"}}}
      iex> put_alias(project, "/fizz", "/foo")
      %Project{aliases: %{"/fizz" => "/foo"}, projects: %{"/foo" => %{"bar" => "baz"}}}

  """
  @spec put_alias(t(), path(), path()) :: t()
  def put_alias(%Project{} = project, from_path, to_path) do
    %Project{project | aliases: Map.put(project.aliases, from_path, to_path)}
  end

  @doc """
  Delete an alias.

  ## Example

      iex> project = %Project{aliases: %{"/fizz" => "/foo"}, projects: %{"/foo" => %{"bar" => "baz"}}}
      iex> delete_alias(project, "/fizz")
      %Project{aliases: %{}, projects: %{"/foo" => %{"bar" => "baz"}}}

  """
  @spec delete_alias(t(), path()) :: t()
  def delete_alias(%Project{} = project, from_path) do
    %Project{project | aliases: Map.delete(project.aliases, from_path)}
  end
end
