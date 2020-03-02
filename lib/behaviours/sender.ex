defmodule Pique.Behaviours.Sender do
  @moduledoc """
  Behaviour for senders. Ideally they should return {:ok, body, state}
  or {:error, reason, state} with reason being a string passed back
  to the SMTP client.
  """
  @callback send(state :: term) :: {:ok, data :: String.t(), new_state :: term} | {:error, reason :: charlist(), state :: term}
end
