defmodule Elasticachex.Socket do
  @moduledoc false

  alias Socket.TCP
  alias Socket.Stream

  @doc """
  Connects to the service
  """
  def connect(host, port, timeout) do
    TCP.connect(host, port, timeout: timeout)
  end

  def close(socket) do
    Socket.Stream.close(socket)
  end

  @doc """
  Sends a command to the socket connection and returns the response.

  ## Example

      iex> send_and_recv(socket, "version\n", 5000)
      {:ok, VERSION 1.4.34\r\n"}
  """
  def send_and_recv(socket, command, timeout) do
    socket |> Stream.send!(command)
    socket |> Stream.recv(timeout: timeout)
  end

end
