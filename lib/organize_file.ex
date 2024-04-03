import FlatFiles

defmodule OrganizeFile do
  def arrange_file(filepath) do
    list_all(filepath)
    |> Enum.map(fn filepath ->
      Task.async(fn ->
        filepath = String.downcase(filepath)
        IO.puts("file path processing >>>>>>>< #{filepath}")

        cond do
          String.ends_with?(filepath, "mkv") or String.ends_with?(filepath, "mov") or
            String.ends_with?(filepath, "avi") or
            String.ends_with?(filepath, "wmv") or String.ends_with?(filepath, "avchd") or
            String.ends_with?(filepath, "mp4") or
            String.ends_with?(filepath, "webm") or String.ends_with?(filepath, "flv") ->
            # move file to videos folder
            mv(filepath, "videos")

          String.ends_with?(filepath, "srt") ->
            # move file to subtitles folder
            mv(filepath, "subtitles")

          String.ends_with?(filepath, ".zip") or String.ends_with?(filepath, ".tar") or
              String.ends_with?(filepath, ".gz") ->
            # move file to compressed folder
            mv(filepath, "compressed")

          String.ends_with?(filepath, "jpg") or String.ends_with?(filepath, "jpeg") or
            String.ends_with?(filepath, "png") or String.ends_with?(filepath, "gif") or
            String.ends_with?(filepath, "raw") or String.ends_with?(filepath, "tiff") ->
            # move file to pictures folder
            mv(filepath, "pictures")

          String.ends_with?(filepath, "mp3") or String.ends_with?(filepath, "m4a") or
            String.ends_with?(filepath, "flac") or String.ends_with?(filepath, "wav") or
            String.ends_with?(filepath, "wma") or String.ends_with?(filepath, "aac") ->
            # move file to music folder
            mv(filepath, "music")

          String.ends_with?(filepath, "pdf") or String.ends_with?(filepath, "doc") or
            String.ends_with?(filepath, "docx") or String.ends_with?(filepath, "oform") or
            String.ends_with?(filepath, "docxf") or String.ends_with?(filepath, "xlsx") or
            String.ends_with?(filepath, "pptx") or String.ends_with?(filepath, "odt") ->
            # move file to documents folder
            mv(filepath, "documents")

          true ->
            nil
        end
      end)
    end)
    |> Enum.each(&Task.await(&1, :infinity))
  end

  defp mv(src, dest) do
    create_dir_if_not_exists("#{Path.dirname(src)}/#{dest}")
    File.cp(src, "#{Path.dirname(src)}/#{dest}/#{Path.basename(src)}")
    File.rm(src)
  end

  defp create_dir_if_not_exists(path) do
    case File.exists?(path) do
      false -> File.mkdir(path)
      true -> nil
    end
  end
end
