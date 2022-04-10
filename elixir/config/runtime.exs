import Config

# Runtime config.

config_path =
  case config_env() do
    :test ->
      "put something here for test"

    :dev ->
      "put something here for dev"

    :prod ->
      System.get_env("XDG_CONFIG_HOME") ||
        raise "Start using an operating system with xdg you goof"
  end

config :projector, Projector, config_path: config_path
