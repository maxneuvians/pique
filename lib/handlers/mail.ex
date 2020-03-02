defmodule Pique.Handlers.MAIL do
  @moduledoc """
  Default implementation of a MAIL handler. Takes an email address
  returns the email address in an {:ok, email} or
  {:error, reason} tuple.
  """
  @behaviour Pique.Behaviours.Handler

  @spec handle(String.t) :: {:ok, String.t}
  def handle(email) do
    {:ok, email}
  end

end
