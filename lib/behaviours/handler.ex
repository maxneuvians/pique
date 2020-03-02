defmodule Pique.Behaviours.Handler do
  @moduledoc """
  Behaviour for handlers. Ideally they should return {:ok, state}
  or {:error, reason} with reason being a string
  passed back to the SMTP client.
  """
  @callback handle(state :: term) :: {:ok, value :: term} | {:error, reason :: term}
end
