defmodule Pique.Handlers.AUTHTest do
  use ExUnit.Case

  import Pique.Handlers.AUTH

  describe "handle/1" do
    test "returns {:ok, :empty} when a username and password are passed" do
      assert handle({"username", "password"}) == {:ok, :empty}
    end
  end

end
