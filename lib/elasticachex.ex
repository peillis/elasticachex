defmodule Elasticachex do
  @moduledoc """
  An implementation of the Node Auto Discovery for Memcached in the
  ElastiCache service of AWS.

  It simply returns the nodes of the cache cluster.
  """

  @timeout 5000  # timeout in ms

  @doc """
  The function to get the cluster info.
  Returns `{:ok, [hosts_list], config_version}` or
  `{:error, reason}`
  """
  def get_cluster_info(host, port \\ 11211) do
    with {:ok, socket} <- connect(host, port),
         {:ok, command} <- get_command(socket),
         {:ok, data} <- send_and_recv(socket, command) do
      digest_cluster_data(data)
    end
  end

  defp digest_cluster_data(data) do
    values = String.split(data, "\n")
    config_version = Enum.at(values, 1)
    hosts = Enum.at(values, 2) |> String.split(" ")
    hosts_list = Enum.reduce(hosts, [], fn(x, acc) ->
      parts = String.split(x, "|")
      ["#{Enum.at(parts, 1)}:#{Enum.at(parts, 2)}" | acc]
    end)
    {:ok, hosts_list, config_version}
  end

  # The command to execute is different depending on versions
  defp get_command(socket) do
    case get_version(socket) do
      {:ok, version} ->
        case Version.compare(version, "1.4.14") do
          :lt -> {:ok, "get AmazonElastiCache:cluster\n"}
          _ -> {:ok, "config get cluster\n"}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  # Gets version number
  defp get_version(socket) do
    case send_and_recv(socket, "version\n") do
      {:ok, data} ->
        <<"VERSION ", version :: binary >> = data
        {:ok, String.trim(version)}
      {:error, reason} -> {:error, reason}
    end
  end

  defp send_and_recv(socket, command) do
    case :gen_tcp.send(socket, command) do
      :ok -> :gen_tcp.recv(socket, 0, @timeout)
      {:error, reason} -> {:error, reason}
    end
  end

  defp connect(host, port) when is_binary(host) do
    connect(String.to_charlist(host), port)
  end
  defp connect(host, port) do
    :gen_tcp.connect(host, port, [:binary, active: false], @timeout)
  end

end
