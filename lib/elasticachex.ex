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


  def main(host, port \\ 11211) do
    case connect(host, port) do
      {:ok, socket} ->
        get_command(socket)
      {:error, reason} -> {:error, reason}
    end
  end

  def get_cluster_info(socket) do
    case get_command(socket) do
      {:ok, command} ->
        case send_and_recv(socket, command) do
          {:ok, data} -> data
          {:error, reason} -> {:error, reason}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  def get_command(socket) do
    case get_version(socket) do
      {:ok, version} ->
        case Version.compare(version, "1.4.14") do
          :lt -> {:ok, "get AmazonElastiCache:cluster\n"}
          _ -> {:ok, "config get cluster\n"}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  def get_version(socket) do
    case send_and_recv(socket, "version\n") do
      {:ok, data} ->
        <<"VERSION ", version :: binary >> = data
        {:ok, String.trim(version)}
      {:error, reason} -> {:error, reason}
    end
  end

  def send_and_recv(socket, command) do
    case :gen_tcp.send(socket, command) do
      :ok -> :gen_tcp.recv(socket, 0, @timeout)
      {:error, reason} -> {:error, reason}
    end
  end

  def connect(host, port) when is_binary(host) do
    connect(String.to_charlist(host), port)
  end
  def connect(host, port) do
    :gen_tcp.connect(host, port, [:binary, active: false], @timeout)
  end

end
