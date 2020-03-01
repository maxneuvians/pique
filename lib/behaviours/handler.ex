defmodule Pique.Behaviours.Handler do
  @callback handle(state :: term) :: :ok | {:ok, new_state :: term} | {:error, reason :: term}
end
