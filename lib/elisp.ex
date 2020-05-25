defmodule Elisp do
  @moduledoc """
  Documentation for `Elisp`.

  Next need to have data lists and literals in pattern-matching
  And strings and floats and integers and data structures
  """

  @context [context: Elixir]
  @meta @context ++ [import: Kernel]

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

  def compile!(charlist, file_name \\ "nofile") do
    charlist
    |> lex!()
    |> parse!()
    |> prepare_module()
    |> Code.compile_quoted(file_name)
  end

  # defp prepare_module({:defmodule, [{name, definitions}]}) do
  #   {:defmodule, @meta,
  #    [{:__aliases__, [alias: false], [name]}, [do: Enum.map(definitions, &prepare_definitions/1)]]}
  # end

  # defp prepare_definitions({:def, [{name, [{args, body}]}]}) do
  #   {:def, @meta, [{name, [context: Elixir], Enum.map(args, &meta/1)}, [do: prepare_body(body)]]}
  # end

  # defp prepare_body([{function, args}]) do
  #   {function, @meta, Enum.map(args, &meta/1)}
  # end

  defp prepare_module([:defmodule, name | definitions]) do
    {:defmodule, @meta, [aliases(name), [do: Enum.map(definitions, &prepare_definitions/1)]]}
  end

  defp prepare_definitions({[:def, name, {args}, {body}]}) do
    {:def, @meta, [{name, @context, Enum.map(args, &meta/1)}, [do: prepare_body(body)]]}
  end

  defp prepare_body([value | []]) do
    value
  end

  defp prepare_body([function | args]) do
    {function, @meta, Enum.map(args, &meta/1)}
  end

  defp aliases(name) do
    {:__aliases__, [alias: false], [name]}
  end

  defp meta(atom) do
    {atom, [], Elixir}
  end
end
