defmodule Pique.TestHandlers.AuthFail do
  @behaviour Pique.Behaviours.Handler

  def handle(_state) do
    {:error, "Failed to pass AUTH handler"}
  end
end

defmodule Pique.TestHandlers.AuthPass do
  @behaviour Pique.Behaviours.Handler

  def handle(_state) do
    {:ok, :empty}
  end
end
