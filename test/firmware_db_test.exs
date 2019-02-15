defmodule FirmwareDbTest do
  use ExUnit.Case
  doctest FirmwareDb

  test "greets the world" do
    assert FirmwareDb.hello() == :world
  end
end
