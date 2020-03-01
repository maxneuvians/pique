defmodule Pique do
  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      %{
        id: :gen_smtp_server,
        start: {:gen_smtp_server, :start_link, [
          Application.get_env(:pique, :callback, Pique.Smtp),
          Application.get_env(:pique, :smtp_opts, [[]])
        ]}
      }
    ]

    opts = [strategy: :one_for_one, name: Pique.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
