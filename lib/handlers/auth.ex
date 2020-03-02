defmodule Pique.Handlers.AUTH do
  @moduledoc """
  Default implementation of an AUTH handler. Takes a tuple
  of username and password and returns a tuple with {:ok, _} or
  {:error, reason}. The reason the second argument in the :ok tuple
  can be blank is because the state does not expect anything back.
  """
  @behaviour Pique.Behaviours.Handler

  @spec handle({String.t, String.t}) :: {:ok, any}
  def handle({_username, _password}) do
    {:ok, :empty}
  end

end
