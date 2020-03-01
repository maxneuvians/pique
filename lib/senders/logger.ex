defmodule Pique.Senders.Logger do
  require Logger
  @behaviour Pique.Behaviours.Sender

  @spec send(map) :: {:ok, String.t, map}
  def send(state) do
    Logger.info("Current state: #{state}")
    {:ok, state[:data], state}
  end

end
