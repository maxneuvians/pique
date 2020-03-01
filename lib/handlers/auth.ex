defmodule Pique.Handlers.AUTH do
  @behaviour Pique.Behaviours.Handler

  @spec handle({String.t, String.t}) :: :ok
  def handle({_username, _password}) do
    :ok
  end

end
