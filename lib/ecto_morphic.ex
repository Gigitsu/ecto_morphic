defmodule EctoMorphic do
  @moduledoc """

  """
  @callback related(any()) :: {:ok, term()} | :error

  @callback castable?(any()) :: boolean()

  defmacro __using__(_) do
    quote do
      @behaviour unquote(__MODULE__)
    end
  end

  def related!(:__default__, %{related: default}), do: default

  def related!(data, %{base_type: base_type}) do
    case base_type.related(data) do
      {:ok, related} ->
        related

      :error ->
        raise ArgumentError, "cannot determine `#{base_type}` type from #{inspect(data)}"
    end
  end
end
