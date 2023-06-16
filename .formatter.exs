[
  import_deps: [:ecto, :phoenix],
  inputs: ["*.{heex,ex,exs}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs}"],
  subdirectories: ["priv/*/migrations"]
]

# [
#   import_deps: [:ecto, :phoenix],
#   # plugins: [Phoenix.LiveView.HTMLFormatter],
#   inputs: ["*.{ex,exs, heex}", "priv/*/seeds.exs", "{config,lib,test}/**/*.{ex,exs,heex}"],
#   subdirectories: ["priv/*/migrations"]
# ]
