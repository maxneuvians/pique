defmodule Pique.Smtp do
  require Logger
  @behaviour :gen_smtp_server_session

  @doc """
  Init callback for new SMTP sessions. Checks if the new initiated session
  exceeds the allowed session count. If it does, responds with an error.
  Otherwise returns the expected banner message.
  """
  @spec init(any, any, any, any) :: {:ok, [...], %{}} | {:stop, :normal, [...]}
  def init(hostname, session_count, _address, _options) do
    if session_count > Application.get_env(:pique, :session_limit, 40) do
      Logger.warn("SMTP server connection limit exceeded")
      {:stop, :normal, ["421", hostname, " is too busy to accept mail right now"]}
    else
      banner = [hostname, " ESMTP"]
      state = %{}
      {:ok, banner, state}
    end
  end

  @doc """
  Handles incoming DATA request. Matches if the message is empty and
  returns an error.
  """
  @spec handle_DATA(any, any, any, map) :: {:error, charlist(), map}
  def handle_DATA(_from, _to, "", state) do
    {:error, '552 Message too small', state};
  end

  @doc """
  Handles incoming DATA request and passes it off to the defined DATA
  handler. If the DATA handler returns an `{:ok, state}` then
  passes the state to the defined send handler. Otherwise returns
  relevant error messages.
  """
  @spec handle_DATA(any, any, String.t, map) :: {:ok, String.t, any} | {:error, charlist(), map}
  def handle_DATA(_from, _to, data, state) do
    Logger.info "Received DATA"
    state = Map.put(state, :body, data)
    case Kernel.apply(
      Application.get_env(:pique, :data_handler, Pique.Handlers.DATA),
      :handle,
      [state]) do
        {:ok, state} ->
          Kernel.apply(
            Application.get_env(:pique, :sender, Pique.Senders.Logger),
            :send,
            [state]
          )
        {:error, msg} ->
          {:error, '552 #{String.to_charlist(msg)}', state}
    end
  end

  @doc """
  Handles incoming EHLO request and returns a list of extensions.
  If the `auth` config is set to true, it automatically adds in
  `AUTH` and `STARTTLS` extensions.
  """
  @spec handle_EHLO(any, any, map) :: {:ok, [any], map}
  def handle_EHLO(hostname, extensions, state) do
    Logger.info("EHLO from #{hostname}")
    case Application.get_env(:pique, :auth, false) do
      true -> {
        :ok,
        extensions ++ [{'AUTH', 'PLAIN LOGIN'}, {'STARTTLS', true}],
        state
      }
      _ -> {:ok, extensions, state}
    end
  end

  @doc """
  Handles incoming HELO request and returns a limit of 640Kb.
  """
  @spec handle_HELO(any, map) :: {:ok, 655_360, map}
  def handle_HELO(hostname, state) do
    Logger.info("HELO from #{hostname}")
    {:ok, 655360, state}
  end

  @doc """
  Handles incoming MAIL request and passes the from address to
  the defined MAIL handler. If the handler passes then adds the
  from address to the state.
  """
  @spec handle_MAIL(any, map) :: {:ok, %{from: map}} | {:error, charlist(), map}
  def handle_MAIL(from, state) do
    Logger.info("MAIL from #{from}")
    case Kernel.apply(
      Application.get_env(:pique, :mail_handler, Pique.Handlers.MAIL),
      :handle,
      [from]) do
        {:ok, from} ->
          {:ok, Map.put(state, :from, from)}
        {:error, msg} ->
          {:error, '550 #{String.to_charlist(msg)}', state}
    end
  end

  @doc """
  Handles MAIL extension requests. Does nothing.
  """
  @spec handle_MAIL_extension(any, map) :: {:ok, map}
  def handle_MAIL_extension(extension, state) do
    Logger.info(extension)
    {:ok, state}
  end

  @doc """
  Handles incoming EHLO request and returns a list of extensions.
  If the `auth` config is set to true, it automatically adds in
  `AUTH` and `STARTTLS` extensions.
  """
  @spec handle_RCPT(any, map) ::
          {:ok, %{rcpt: nonempty_maybe_improper_list}} | {:error, charlist(), map}
  def handle_RCPT(to, state) do
    Logger.info("RCPT to #{to}")
    case Kernel.apply(
      Application.get_env(:pique, :rcpt_handler, Pique.Handlers.RCPT),
      :handle,
      [to]) do
        {:ok, to} ->
          {:ok, Map.put(state, :rcpt, [to] ++ Map.get(state, :rcpt, []))}
        {:error, msg} ->
          {:error, '550 #{String.to_charlist(msg)}', state}
    end
  end

  @doc """
  Handles RCPT extension requests. Does nothing.
  """
  @spec handle_RCPT_extension(any, map) :: {:ok, map}
  def handle_RCPT_extension(extension, state) do
    Logger.info(extension)
    {:ok, state}
  end

  @doc """
  Handles RSET requests by removing the existing envelope
  information from the state.
  """
  @spec handle_RSET(map) :: {:ok, map}
  def handle_RSET(state) do
    state =
      state
      |> Map.delete(:rcpt)
      |> Map.delete(:from)
      |> Map.delete(:body)

    {:ok, state}
  end

  @doc """
  Handles VRFY requests by telling people to go away.
  """
  @spec handle_VRFY(any, any) ::
          {:error, [32 | 50 | 53 | 78 | 101 | 111 | 114 | 115 | 116 | 117, ...], any}
  def handle_VRFY(address, state) do
    Logger.info("VRFY for #{address}")
    {:error, '252 Not sure', state}
  end

  @doc """
  Handles incoming AUTH request and passes it off to the defined AUTH
  handler. If the AUTH handler returns an `{:ok, state}`. Otherwise
  returns relevant error messages.
  """
  @spec handle_AUTH(any, any, any, any) :: {:ok, any} | {:error, charlist(), any}
  def handle_AUTH(type, username, password, state) when type == :login or type == :plain do
    Logger.info("AUTH request")
    case Kernel.apply(
      Application.get_env(:pique, :auth_handler, Pique.Handlers.AUTH),
      :handle,
      [{username, password}]) do
        {:ok, _} ->
          {:ok, state}
        {:error, msg} ->
          {:error, '530 #{String.to_charlist(msg)}', state}
    end
  end

  @doc """
  Handles incoming AUTH request that do not use the PLAIN or
  LOGIN type - looking at you CRAM-MD5. Telling client to use
  PLAIN or LOGIN.
  """
  def handle_AUTH(_type, _username, _password, state) do
    {:error, '530 Use PLAIN or LOGIN', state}
  end

  @doc """
  Handles incoming unkown request. Telling client that
  it does not understand.
  """
  @spec handle_other(any, any, any) :: {charlist(), any}
  def handle_other(command, _args, state) do
    Logger.info(command)
    {'500 Error: command not recognized : #{command}', state}
  end

  @doc """
  Handles hot swap code change (in theory). Does nothing in
  practice.
  """
  @spec code_change(any, any, any) :: {:ok, any}
  def code_change(_old, state, _extra) do
    {:ok, state}
  end

  @doc """
  Handles session termination. Does nothing.
  """
  @spec terminate(String.t, map) :: {:ok, map}
  def terminate(reason, state) do
    Logger.info("Terminating Session: #{reason}")
    {:ok, state}
  end
end
