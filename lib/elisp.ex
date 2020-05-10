defmodule Elisp do
  @moduledoc """
  Documentation for `Elisp`.
  """

  @meta [context: Elixir, import: Kernel]

  def lex!(charlist) do
    charlist
    |> :lexer.string()
    |> case do
      {:ok, lexed, _} -> lexed
      {:error, reason} -> raise inspect(reason)
    end
  end

  def parse!(tokens) do
    tokens
    |> :parser.parse()
    |> case do
      {:ok, parsed} -> parsed
      {:error, reason} -> raise inspect(reason)
    end
  end

  def compile!(charlist) do
    charlist
    |> lex!()
    |> parse!()
    |> prepare_module()
    |> Code.compile_quoted()
  end

  defp prepare_module({:defmodule, [{name, definitions}]}) do
    {:defmodule, @meta,
     [{:__aliases__, [alias: false], [name]}, [do: prepare_definitions(definitions)]]}
  end

  defp prepare_definitions([{:def, [{name, [{args, body}]}]}]) do
    {:def, @meta, [{name, [context: Elixir], Enum.map(args, &meta/1)}, [do: prepare_body(body)]]}
  end

  defp prepare_body([{function, args}]) do
    {function, @meta, Enum.map(args, &meta/1)}
  end

  defp meta(atom) do
    {atom, [], Elixir}
  end
end
