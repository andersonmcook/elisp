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

  # Build module AST
  defp prepare_module([:defmodule, name | definitions]) do
    {:defmodule, @meta, [aliases(name), [do: Enum.map(definitions, &prepare_definitions/1)]]}
  end

  # Build function declarations AST
  defp prepare_definitions({[:def, name, {args}, {body}]}) do
    {:def, @meta, [{name, @context, Enum.map(args, &meta/1)}, [do: prepare_body(body)]]}
  end

  # Build individual functions AST
  # How would this handle a nullary function?
  defp prepare_body([value | []]) do
    value
  end

  defp prepare_body([function | args]) do
    {function, @meta, Enum.map(args, &meta/1)}
  end

  # Aliases module
  defp aliases(name) do
    {:__aliases__, [alias: false], [name]}
  end

  defp meta(arg) when is_atom(arg) do
    {arg, [], Elixir}
  end

  defp meta({[function | args]}) do
    {function, [], Enum.map(args, &meta/1)}
  end
end
