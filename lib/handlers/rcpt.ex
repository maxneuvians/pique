defmodule Pique.Handlers.RCPT do
  @behaviour Pique.Behaviours.Handler

  @spec handle(map) :: {:ok, map}
  def handle(email) do
    {:ok, email}
  end

end
