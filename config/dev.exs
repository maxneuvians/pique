use Mix.Config

config :pique,
  auth: true,
  smtp_opts: [
    port: 3000,
    protocol: :tcp,
    sessionoptions: [
      certfile: "foo",
      keyfile: "bar"
    ]
  ]

