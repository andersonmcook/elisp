defmodule Mix.Tasks.Compile.Tl do
  @moduledoc "Compiles Terrible Lisp files"

  use Mix.Task.Compiler

  @impl true
  def run(args) do
    IO.inspect(args, label: "mix task args")
    # Elisp.compile!(charlist)
    # files/*.tl files

    project = Mix.Project.config()

    source_paths = project[:tlc_paths] || ["/files"]

    Enum.each(source_paths, fn path ->
      full_path = Path.join(File.cwd!(), path)

      full_path
      |> File.ls!()
      |> Enum.each(fn file ->
        full_path
        |> Path.join(file)
        |> File.read!()
        |> String.to_charlist()
        |> Elisp.compile!()
        |> IO.inspect()
      end)
    end)

    :ok
  end

  # def clean do
  ## do cleanup here
  # end
  #
  # def manifests do
  ## manifests stuff
  # end
end
