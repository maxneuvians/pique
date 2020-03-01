defmodule Pique.Behaviours.Sender do
  @callback send(state :: term) :: {:ok, data :: String.t(), new_state :: term} | {:error, reason :: charlist(), state :: term}
end
