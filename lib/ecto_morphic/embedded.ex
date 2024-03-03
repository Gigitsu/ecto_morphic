defmodule EctoMorphic.Embedded do
  @moduledoc """
  The embedding struct for `embeds_polymorphic`

  Its fields are:

    * `cardinality` - The association cardinality, only :one is currently supported
    * `field` - The name of the association field on the schema
    * `owner` - The schema where the association was defined
    * `related` - The schema that is embedded
    * `on_cast` - Function name to call by default when casting embeds
    * `on_replace` - The action taken on associations when schema is replaced

  """
  alias __MODULE__
  alias Ecto.Changeset.Relation

  use Ecto.ParameterizedType

  @behaviour Relation

  defstruct [
    :base_type,
    :cardinality,
    :field,
    :owner,
    :related,
    :on_cast,
    on_replace: :raise,
    unique: true,
    ordered: true
  ]

  ## Parameterized API

  @impl Ecto.ParameterizedType
  def type(_), do: {:map, :any}

  @impl Ecto.ParameterizedType
  def init(opts) do
    Ecto.Embedded.init(opts)

    struct(%Embedded{}, Keyword.put_new(opts, :on_replace, :raise))
  end

  @impl Ecto.ParameterizedType
  def load(nil, _fun, %{cardinality: :one}), do: {:ok, nil}

  def load(value, fun, %{related: nil} = embed) do
    load(value, fun, %{embed | related: EctoMorphic.related!(value, embed)})
  end

  def load(value, fun, %{cardinality: :one, related: schema, field: field}) when is_map(value) do
    {:ok, load_field(field, schema, value, fun)}
  end

  def load(nil, _fun, %{cardinality: :many}), do: {:ok, []}

  def load([head | _] = value, fun, %{related: nil} = embed) do
    load(value, fun, %{embed | related: EctoMorphic.related!(head, embed)})
  end

  def load(value, fun, %{cardinality: :many, related: schema, field: field})
      when is_list(value) do
    {:ok, Enum.map(value, &load_field(field, schema, &1, fun))}
  end

  def load(_value, _fun, _embed) do
    :error
  end

  defp load_field(_field, schema, value, loader) when is_map(value) do
    Ecto.Schema.Loader.unsafe_load(schema, value, loader)
  end

  defp load_field(field, _schema, value, _fun) do
    raise ArgumentError, "cannot load embed `#{field}`, expected a map but got: #{inspect(value)}"
  end

  @impl Ecto.ParameterizedType
  def dump(nil, _, _), do: {:ok, nil}

  def dump(%{__struct__: schema} = value, fun, %{related: nil} = embed) do
    dump(value, fun, %{embed | related: schema})
  end

  def dump(value, fun, %{cardinality: :one, related: schema, field: field}) when is_map(value) do
    {:ok, dump_field(field, schema, value, schema.__schema__(:dump), fun, _one_embed? = true)}
  end

  def dump(value, fun, %{cardinality: :many, related: schema, field: field})
      when is_list(value) do
    types = schema.__schema__(:dump)
    {:ok, Enum.map(value, &dump_field(field, schema, &1, types, fun, _one_embed? = false))}
  end

  def dump(_value, _fun, _embed) do
    :error
  end

  defp dump_field(_field, schema, %{__struct__: schema} = struct, types, dumper, _one_embed?) do
    Ecto.Schema.Loader.safe_dump(struct, types, dumper)
  end

  defp dump_field(field, schema, value, _types, _dumper, one_embed?) do
    one_or_many =
      if one_embed?,
        do: "a struct #{inspect(schema)} value",
        else: "a list of #{inspect(schema)} struct values"

    raise ArgumentError,
          "cannot dump embed `#{field}`, expected #{one_or_many} but got: #{inspect(value)}"
  end

  @impl Ecto.ParameterizedType
  def cast(nil, %{cardinality: :one}), do: {:ok, nil}

  def cast(%{__struct__: schema} = struct, %{cardinality: :one, base_type: base_type}) do
    if base_type.castable?(schema),
      do: {:ok, struct},
      else: :error
  end

  def cast(nil, %{cardinality: :many}), do: {:ok, []}

  def cast(value, %{cardinality: :many, base_type: base_type}) when is_list(value) do
    if Enum.all?(value, &base_type.castable?(&1)),
      do: {:ok, value},
      else: :error
  end

  def cast(_value, _embed) do
    :error
  end

  @impl Ecto.ParameterizedType
  def embed_as(_, _), do: :dump

  @impl Relation
  def build(%Embedded{related: related}, _owner) do
    related.__struct__
  end

  def preload_info(_embed) do
    :embed
  end
end
