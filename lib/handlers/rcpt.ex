defmodule Pique.Handlers.RCPT do
  @moduledoc """
  Default implementation of a RCPT handler. Takes a the current state
  of the smtp session and returns the state in an {:ok, state} or
  {:error, reason} tuple.
  """
  @behaviour Pique.Behaviours.Handler

  @spec handle(String.t) :: {:ok, String.t}
  def handle(email) do
    {:ok, email}
  end

end
