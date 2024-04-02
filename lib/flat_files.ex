defmodule FlatFiles do
  # Credits: The logic for implementing listing files in a sub-directory was gotten from Sophie DeBenedetto.
  def list_all(filepath) do
    _list_all(filepath)
  end

  defp _list_all(filepath) do
    IO.puts("tracing >>> #{filepath}")
    cond do
      String.starts_with?(filepath, ".") -> []
      true -> expand(File.ls(filepath), filepath)
    end
  end

  defp expand({:ok, files}, path) do
    # files
    # |> Enum.flat_map(&_list_all("#{path}/#{&1}"))
    files
    |> Enum.flat_map(fn file -> _list_all("#{path}/#{file}") end)
  end

  defp expand({:error, _}, path) do
    # this clause fires when the path is a file and not a directory
    [path]
  end
end
