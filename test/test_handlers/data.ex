defmodule Pique.TestHandlers.DataFail do
  @behaviour Pique.Behaviours.Handler

  def handle(_state) do
    {:error, "Failed to pass DATA handler"}
  end
end

defmodule Pique.TestHandlers.DataPass do
  @behaviour Pique.Behaviours.Handler

  def handle(state) do
    {:ok, state}
  end
end
