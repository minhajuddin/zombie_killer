defmodule ZKTest do
  use ExUnit.Case
  doctest ZK

  test "greets the world" do
    assert ZK.hello() == :world
  end
end
