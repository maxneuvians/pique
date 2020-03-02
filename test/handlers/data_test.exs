defmodule Pique.Handlers.DATATest do
  use ExUnit.Case

  import Pique.Handlers.DATA

  describe "handle/1" do
    test "returns {:ok, state} state is passed passed" do
      assert handle(%{}) == {:ok, %{}}
    end
  end

end
