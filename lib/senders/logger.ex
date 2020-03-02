defmodule Pique.Senders.Logger do
  @moduledoc """
  Default implementation of a sender. Takes the current state
  of the smtp session, logs it, and returns the state in an
  {:ok, data, state} or {:error, reason} tuple.
  """
  require Logger
  @behaviour Pique.Behaviours.Sender

  @spec send(map) :: {:ok, String.t, map}
  def send(state) do
    Logger.info("Current state: #{inspect(state)}")
    {:ok, state[:data], state}
  end

end
