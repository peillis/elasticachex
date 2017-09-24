defmodule Elasticachex.Socket do

  @doc """
  Sends a command to the socket connection and returns the response.

  ## Example

      iex> send_and_recv(socket, "version\n", 5000)
      {:ok, VERSION 1.4.34\r\n"}
  """
  def send_and_recv(socket, command, timeout) do
    socket |> Socket.Stream.send!(command)
    socket |> Socket.Stream.recv(timeout: timeout)
  end

end
