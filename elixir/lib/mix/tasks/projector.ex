defmodule Mix.Tasks.Projector do
  @moduledoc """
  Command Line Interface for the Elixir Projector version.

      mix projector [--pwd PATH] [--config PATH] print [key]
      mix projector [--pwd PATH] [--config PATH] [key]

  prints out the configuration for the current directory and its parents. If you
  provide no arguments to projector, this is the default behavior.

      mix projector [--pwd PATH] [--config PATH] link /absolute/to/other/directory

  will link the cwd (or pwd) to another directories config. This is useful for
  mirroring configs.

      mix projector [--pwd PATH] [--config PATH] unlink

  will remove any previously established link.

      mix projector [--pwd PATH] [--config PATH] del key_to_delete

  deletes a key in the current directories config. Will not delete key out of
  parent.

      mix projector [--pwd PATH] [--config PATH] add key_to_add value

  adds key and value to the current directories config.

      mix projector [--pwd PATH] [--config PATH] which

  shows the current path to the config file.

  ## Examples

      mix projector --pwd /foo add foo "some value for foo"

  """

  use Mix.Task

  @shortdoc "Command Line Interface for the Elixir Projector version"

  @impl Mix.Task
  def run(args) do
    case Projector.Opts.parse(args) do
      {options, []} ->
        IO.inspect(options, label: "OPTIONS")
        command("print", [], options)

      {options, [command | rest]} ->
        IO.inspect(command, label: "COMMAND")
        IO.inspect(rest, label: "REST")
        IO.inspect(options, label: "OPTIONS")
        command(command, rest, options)
    end
  end

  def command("print", [], _options) do
    # TODO
  end

  def command("add", [key | rest], options) do
    # TODO
  end

  def command("del", [key], options) do
    # TODO
  end

  def command("link", [to_path], options) do
    # TODO
  end

  def command("unlink", [path], options) do
    # TODO
  end

  def command("which", [], options) do
    # TODO
  end

  def command(command, rest, options) do
    raise ArgumentError,
      message:
        "Invalid command: #{command}, with args: #{inspect(rest)}, and options: #{inspect(options)}"
  end
end
