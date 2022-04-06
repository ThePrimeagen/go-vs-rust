defmodule ProjectorTest do
  use ExUnit.Case
  doctest Projector

  test "greets the world" do
    assert Projector.hello() == :world
  end
end
