defmodule Elasticachex do
  @moduledoc """
  Documentation for Elasticachex.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Elasticachex.hello
      :world

  """
  @timeout 5000  # timeout in ms

  def connect(host, port) when is_binary(host) do
    connect(String.to_charlist(host), port)
  end
  def connect(host, port) do
    :gen_tcp.connect(host, port, [:binary, active: false], @timeout)
  end

  def main(host, port \\ 11211) do
    case connect(host, port) do
      {:ok, socket} ->
        :ok = :gen_tcp.send(socket, "get AmazonElastiCache:cluster")
        case :gen_tcp.recv(socket, 0, @timeout) do
          {:ok, packet} -> packet
          {:error, reason} -> {:error, reason}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  def get_version(socket) do
    case :gen_tcp.send(socket, "version\n") do
      :ok ->
        case read(socket) do
          {:error, reason} -> {:error, reason}
          data ->
            <<"VERSION ", version :: binary >> = data
            String.trim(version)
        end
      {:error, reason} -> {:error, reason}
    end
  end

  def read(socket) do
    case :gen_tcp.recv(socket, 0, @timeout) do
      {:ok, data} -> data
      {:error, reason} -> {:error, reason}
    end
  end
end
