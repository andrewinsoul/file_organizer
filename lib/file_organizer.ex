import OrganizeFile

defmodule FileOrganizer.CLI do
  @moduledoc """
  Documentation for `FileOrganizer`.
  """
  defp collect_directory do
    directory =
      IO.gets("Enter directory relative to home where you want your files to be organized in? ")
      |> String.trim()

    cond do
      String.starts_with?(directory, "/") ->
        Path.expand(
          String.replace(
            directory,
            "/",
            "",
            global: false
          ),
          "~"
        )

      true ->
        Path.expand(directory, "~")
    end
  end

  def main(_args) do
    dir = collect_directory()
    arrange_file(dir)
  end
end
