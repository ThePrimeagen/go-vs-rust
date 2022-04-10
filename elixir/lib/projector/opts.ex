defmodule Projector.Opts do
  @moduledoc """
  Options Parsing.
  """

  @typedoc "A list of args."
  @type args :: [String.t()]

  @typedoc "A string of args."
  @type argv :: String.t()

  @typedoc "A keyword list of the parsed args."
  @type parsed :: keyword()

  @doc """
  Parse the options. Accepts a list or string of args.

  ## Examples

      iex> parse("-p /foo")
      {[pwd: "/foo"], []}

      iex> parse("-p /foo --command add")
      {[pwd: "/foo", command: "add"], []}

  """
  @spec parse(argv() | args()) :: {parsed(), rest :: args()}
  def parse(argv) when is_binary(argv) do
    OptionParser.split(argv) |> parse()
  end

  def parse(args) when is_list(args) do
    OptionParser.parse!(args,
      strict: [
        config: :string,
        pwd: :string,
        command: [:string, :keep]
      ],
      aliases: [
        c: :config,
        p: :pwd
      ]
    )
  end
end
