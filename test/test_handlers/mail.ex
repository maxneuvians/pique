defmodule Pique.TestHandlers.MailFail do
  @behaviour Pique.Behaviours.Handler

  def handle(_state) do
    {:error, "Failed to pass MAIL handler"}
  end
end

defmodule Pique.TestHandlers.MailPass do
  @behaviour Pique.Behaviours.Handler

  def handle(state) do
    {:ok, state}
  end
end
