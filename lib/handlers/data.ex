defmodule Pique.Handlers.DATA do
  @moduledoc """
  Default implementation of a DATA handler. Takes a the current state
  of the smtp session and returns the state in an {:ok, state} or
  {:error, reason} tuple.
  """
  @behaviour Pique.Behaviours.Handler

  @spec handle(map) :: {:ok, map}
  def handle(state) do
    {:ok, state}
  end

end
