defmodule Mix.Tasks.Compile.Tl do
  @moduledoc "Compiles Terrible Lisp files"

  use Mix.Task.Compiler

  @impl true
  def run(args) do
    # IO.inspect(args, label: "mix task args")
    # Elisp.compile!(charlist)
    # files/*.tl files

    project = Mix.Project.config()
    # IO.inspect(project)

    source_paths = project[:tlc_paths] || ["/files"]

    Enum.each(source_paths, fn path ->
      full_path = Path.join(File.cwd!(), path)

      full_path
      |> File.ls!()
      |> Enum.each(fn file ->
        file_path = Path.join(full_path, file)

        file_path
        |> File.read!()
        |> String.to_charlist()
        |> Elisp.compile!(file_path)
        |> write_file()
      end)
    end)

    :ok
  end

  @impl true
  def clean do
    file = manifest()

    file
    |> File.read!()
    |> :erlang.binary_to_term()
    |> elem(1)
    |> Enum.each(fn {file, _} -> File.rm!(file) end)

    File.rm!(file)
  end

  @impl true
  def manifests do
    [manifest()]
  end

  defp manifest do
    Path.join(Mix.Project.manifest_path(), "compile.tl")
  end

  defp write_file([{module_name, byte_code}]) do
    module_name =
      module_name
      |> Module.split()
      |> Enum.join(".")

    file_name = "tl.#{module_name}.beam"

    dir_path =
      Path.join([
        "_build",
        "#{Mix.env()}",
        "lib",
        "#{Mix.Project.config()[:app]}",
        "ebin"
      ])

    File.mkdir_p!(dir_path)

    dir_path
    |> Path.join(file_name)
    |> File.write!(byte_code)
  end

  # compile the file
  # do some kind of conversion
  # write it to disk
  #
  # figure out what's stale and only recompile that, if you changed a file, it's available for recompilation
end
