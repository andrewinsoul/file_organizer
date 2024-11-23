defmodule FileOrganizer.HandleProcess do
  use GenServer

  def start_link do
    GenServer.start_link(__MODULE__, [])
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def organize_file(receiver_pid, file_path) do
    GenServer.cast(receiver_pid, {:process_file, file_path})
  end

  defp determine_file_type(filepath) do
    image_regex = ~r/\.(png|jpg|svg|gif|ico|jpeg)\z/
    music_regex = ~r/\.(mp3|aud|ogg|wma|aac)\z/
    video_regex = ~r/\.(mkv|mp4|flv|mov|webm)\z/
    doc_regex = ~r/\.(ppt|docx|doc|csv|pdf|xxlx)\z/
    compressed_regex = ~r/\.(zip|tar|gz)\z/
    subtitle_regex = ~r/\.(srt)\z/

    cond do
      Regex.match?(image_regex, filepath) -> "image"
      Regex.match?(music_regex, filepath) -> "music"
      Regex.match?(video_regex, filepath) -> "video"
      Regex.match?(doc_regex, filepath) -> "docs"
      Regex.match?(compressed_regex, filepath) -> "compressed"
      Regex.match?(subtitle_regex, filepath) -> "subtitle"
      true -> nil
    end
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

  def handle_cast({:process_file, path}, state) do
    if path == :kill do
      IO.puts("Yay, your directory was successfully organized...")
      System.stop()
    else
      filepath = String.downcase(path)

      case determine_file_type(filepath) do
        "image" -> mv(filepath, "pictures")
        "video" -> mv(filepath, "videos")
        "music" -> mv(filepath, "music")
        "docs" -> mv(filepath, "documents")
        "compressed" -> mv(filepath, "compressed")
        "subtitle" -> mv(filepath, "subtitles")
        _ -> nil
      end

      IO.puts("<<<<<<<<< #{filepath} was moved successfully!!!")
    end

    {:noreply, state}
  end
end
