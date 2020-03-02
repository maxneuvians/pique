# Pique

An elixir wrapper around the excellent [`gen_smtp` server](https://github.com/gen-smtp/gen_smtp) that makes handler and sender registration easier. 

## Rational or Why do I need this?

The internet is awesome - sending emails is ok. Email is made more awesome by services like Amazon SES and Mailgun that allow you to send emails  using APIs - especially if you allow you customers to send email on your behalf through your own API. It gives you an opportunity to scan those  emails before they go out for content that should not be in there (ex. personal identifiable information).

However, some customers only use SMTP and can not use your awesome API, what then? How do you have the same level of introspection into the emails that are sent through SMTP as through your API? Simple, build your own SMTP server that then pipes the message to that API.

This package uses the server provided by [`gen_smtp`](https://github.com/gen-smtp/gen_smtp), and allows you to register handlers with various SMTP actions, so that you don't have to deal with all the SMTP stuff, but can focus on what matters. 

## Usage

Using your `Mix.Config` files you can specify a number of `handlers` and a `sender` whose behaviour is defined in `lib/behaviours/handler.ex` and `lib/behaviours/sender.ex` respectively. There exist default `handlers` that just pass through the data and a default `sender` that logs the SMTP message to the console. Best to use an example:

If I wanted to block all SMTP messages being sent from a specific email address before they get sent I might write a `handler` like this:

```elixir
defmodule MyApp.MailHander do
  @behaviour Pique.Behaviours.Handler

  def handle("nefarious.fellow@canada.org"), do: {:error, "Go away nefarious fellow"}
  def handle(email), do: {:ok, email}

end
```

and register that `handler` using my config:

```elixir
config :pique,
  mail_handler: MyApp.MailHander
```

Similary if I actually wanted to send my email through AWS SES I could create a new `sender`:

```elixir
defmodule MyApp.SESSender do
  @behaviour Pique.Behaviours.Sender
  alias ExAws.{SES}

  def send(state) do
    SES.send_raw_email(state[:data])
    {:ok, state[:data], state}
  end

end
```

and register that `handler` using my config:

```elixir
config :pique,
  sender: MyApp.SESSender
```

I have thereby created some amorphous monster of SMTP->SES with custom logic.

Below is a table of each available `handler` and what it does:

| Type | Config Name | Default | Description |
|---|---|---|---|
| Auth | `auth_handler` | `lib/handlers/auth.ex` | Handles any authentication requests |
| Data | `data_handler` | `lib/handlers/data.ex` | Handles the body of the email to be sent |
| Mail | `mail_handler` | `lib/handlers/mail.ex` | Handles the from address |
| Rcpt | `rcpt_handler` | `lib/handlers/rcpt.ex` | Handles any recipients of the email, including bcc |
| Send | `sender` | `lib/senders/logger.ex` | Logs the state of the SMTP session instead of sending it |

## Installation

The package can be installed by adding `pique` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:pique, "~> 0.1.0"}
  ]
end
```
## Documentation

Documentation can be found at [https://hexdocs.pm/pique](https://hexdocs.pm/pique).

## License

MIT
