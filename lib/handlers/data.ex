defmodule Pique.Handlers.DATA do
  @behaviour Pique.Behaviours.Handler

  @spec handle(map) :: {:ok, map}
  def handle(state) do
    {:ok, state}
  end

end
