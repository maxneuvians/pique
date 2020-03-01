defmodule Pique.TestHandlers.RcptFail do
  @behaviour Pique.Behaviours.Handler

  def handle(_state) do
    {:error, "Failed to pass RCPT handler"}
  end
end

defmodule Pique.TestHandlers.RcptPass do
  @behaviour Pique.Behaviours.Handler

  def handle(state) do
    {:ok, state}
  end
end
