import Config

if config_env() == :prod do
  config :redirector, RedirectorWeb.Endpoint,
    server: true,
    http: [
      ip: {0, 0, 0, 0},
      port: String.to_integer(System.get_env("PORT") || "4000")
    ]
end
