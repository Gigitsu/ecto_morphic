defmodule EctoMorphic.Schema do
  @moduledoc """

  """

  defmacro embeds_polymorphic(name, schema, opts \\ []) do
    schema = expand_alias(schema, __CALLER__)

    quote bind_quoted: [name: name, schema: schema, opts: opts] do
      EctoMorphic.Schema.__embeds_polymorphic__(__MODULE__, name, schema, opts)
    end
  end

  @doc false
  def __embeds_polymorphic__(mod, name, schema, opts) do
    opts = [cardinality: :one, owner: mod, field: name, base_type: schema] ++ expand_default(opts)
    Ecto.Schema.__field__(mod, name, EctoMorphic.Embedded, opts)

    [{^name, {_, EctoMorphic.Embedded, struct}} | fields] =
      Module.delete_attribute(mod, :ecto_changeset_fields)

    fields |> Enum.reverse() |> Enum.each(&Module.put_attribute(mod, :ecto_changeset_fields, &1))

    Module.put_attribute(mod, :ecto_changeset_fields, {name, {:embed, struct}})
    Module.put_attribute(mod, :ecto_embeds, {name, struct})
  end

  defp expand_default(opts) do
    case Keyword.fetch(opts, :default) do
      {:ok, schema} when is_atom(schema) ->
        opts
        |> Keyword.put(:default, struct(schema))
        |> Keyword.put(:related, schema)

      _ ->
        opts
    end
  end

  defp expand_alias({:__aliases__, _, _} = ast, env), do: Macro.expand(ast, env)
  defp expand_alias(ast, _env), do: ast
end
