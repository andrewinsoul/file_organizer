import FlatFiles
alias FileOrganizer.HandleProcess

defmodule OrganizeFile do
  def arrange_file(filepath) do
    {:ok, pid} = HandleProcess.start_link()

    (list_all(filepath) ++ [:kill])
    |> Enum.each(fn filepath ->
      IO.puts("Processing >>>>>>>> #{filepath}")
      HandleProcess.organize_file(pid, filepath)
    end)

    :timer.sleep(:infinity)
  end
end
