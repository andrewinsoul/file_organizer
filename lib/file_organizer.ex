"""
TODO:
 - List all files and folders in selected folder in an array
 - Flatten item
 - 
"""

defmodule FileOrganizer.CLI do
  @moduledoc """
  Documentation for `FileOrganizer`.
  """

  def list_files_and_dir(path \\ "") do
    {:ok, file_list} = File.ls(Path.expand(path, "~"))
    file_list |> Enum.map(fn item -> Path.expand(item, "~") end)
  end

  def fetch_all_files_in_dir(path, list \\ [])

  def fetch_all_files_in_dir(path, list) do
    cond do
      File.dir?(path) ->
        list_files_and_dir(path) |>
        Enum.each(fn item -> fetch_all_files_in_dir(item) end)
      true -> [path | list]
    end
  end

  def fetch_all_files_in_dir(path, list_arg) do
    {:ok, list} = File.ls(path)
  end


  # def flatten(list, bucket \\ [])

  # def flatten(list, bucket), do: bucket


  # @spec flattener(
  #         binary()
  #         | maybe_improper_list(
  #             binary() | maybe_improper_list(any(), binary() | []) | char(),
  #             binary() | []
  #           )
  #       ) :: list()
  # def flattener(path) do
  #   cond do
  #     File.dir?(path) ->
  #       list_files_and_dir(path)
  #     true -> @bucket
  #   end
  # end

  # def flatten(list, bucket) do
  #   multiply = fn n ->
  #     n * 2
  #   end
  #   [2,4,6,8] |> Enum.map(multiply)
  # end

  def main(args \\ []) do
  end
end
