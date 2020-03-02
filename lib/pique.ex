defmodule Pique do
  @moduledoc """
  Main Pique application. Starts the `gen_smtp_server` with the
  default configuration. If the configuration states
  that `auth` is `true` then the application will not start unless
  it is configured with `sessionoptions` that specify a cert and key
  file as well as listening on `:ssl` vs. `:tcp`.

  Example SSL configuration:
  ```
  config :pique,
    auth: true,
    smtp_opts: [
      port: 4646,
      protocol: :ssl,
      sessionoptions: [
        certfile: "foo",
        keyfile: "bar"
      ]
    ]
  ```
  """
  require Logger
  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do

    smtp_options = Application.get_env(:pique, :smtp_opts, [])

    children = [
      %{
        id: :gen_smtp_server,
        start: {:gen_smtp_server, :start_link, [
          Application.get_env(:pique, :callback, Pique.Smtp),
          [smtp_options]
        ]}
      }
    ]

    # Check if SSL is configured properly
    validate_ssl_options(smtp_options)

    opts = [strategy: :one_for_one, name: Pique.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @spec validate_ssl_options(any) :: nil
  def validate_ssl_options(smtp_options) do
    if Application.get_env(:pique, :auth) == true do
      if !Keyword.has_key?(smtp_options, :protocol) or Keyword.get(smtp_options, :protocol) == :tcp do
        Logger.error("Pique auth set to true, but protocol needs to be :ssl")
        exit(:shutdown)
      end

      if !Keyword.has_key?(smtp_options, :sessionoptions) do
        Logger.error("Pique auth set to true, but no sessionoptions defined")
        exit(:shutdown)
      end

      options = smtp_options[:sessionoptions]

      if !Keyword.has_key?(options, :certfile) do
        Logger.error("Pique auth set to true, but no certfile specified")
        exit(:shutdown)
      end

      if !Keyword.has_key?(options, :keyfile) do
        Logger.error("Pique auth set to true, but no keyfile specified")
        exit(:shutdown)
      end

    end
  end
end
