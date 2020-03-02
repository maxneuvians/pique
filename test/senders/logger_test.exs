defmodule Pique.Senders.LoggerTest do
  use ExUnit.Case
  import ExUnit.CaptureLog

  import Pique.Senders.Logger

  describe "send/1" do
    test "returns {:ok, data, state} state is passed passed" do
      assert send(%{data: "foo"}) == {:ok, "foo", %{data: "foo"}}
    end

    test "logs the passed state" do
      assert capture_log(fn ->
        send(%{data: "foo"})
      end) =~ "Current state: %{data: \"foo\"}"
    end
  end

end
