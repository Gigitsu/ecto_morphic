# Used by "mix format"
locals_without_parens = [embeds_polymorphic: 2, embeds_polymorphic: 3]

[
  locals_without_parens: locals_without_parens,
  export: [locals_without_parens: locals_without_parens],
  import_deps: [:ecto],
  inputs: ["{mix,.formatter}.exs", "{config,lib,test}/**/*.{ex,exs}"]
]
