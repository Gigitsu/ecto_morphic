defmodule EctoMorphic.Changeset do
  alias Ecto.Changeset

  def cast_polymorphic_embed(%{types: types} = changeset, field, opts \\ []) do
    embed = embed!(types, field)
    related = changeset |> get_field(field) |> EctoMorphic.related!(embed)

    # The related schema module will be set as the embedded type here.
    {:embed, %EctoMorphic.Embedded{} = relation} = Map.fetch!(types, field)

    # We must modify the type so Ecto will handle this field as an embed.
    changeset =
      %{changeset | types: Map.put(types, field, {:embed, %{relation | related: related}})}

    Changeset.cast_embed(changeset, field, Keyword.put(opts, :with, &related.changeset/2))
  end

  defp get_field(%{params: params, data: data}, field) do
    with nil <- Map.get(params, "#{field}"), nil <- Map.get(data, field), do: :__default__
  end

  defp embed!(types, name) do
    case types do
      %{^name => {:embed, embed}} ->
        embed

      %{^name => {type, _}} ->
        raise ArgumentError,
              "expected `#{name}` to be an embed in `cast_polymorphic_embed`, got: `#{type}`"

      _ ->
        raise ArgumentError,
              "cannot cast polymorphic embed `#{name}`, embed `#{name}` not found. Make sure that it exists and is spelled correctly"
    end
  end
end
