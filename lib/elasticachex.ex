defmodule Elasticachex do
  @moduledoc """
  An implementation of the Node Auto Discovery for Memcached in the
  ElastiCache service of AWS.

  It simply returns the nodes of the cache cluster.
  """
  @socket Application.get_env(:elasticachex, :socket_module,
                              Elasticachex.Socket)
  @timeout Application.get_env(:elasticachex, :timeout, 5000)

  @doc """
  The function to get the cluster info.
  Returns `{:ok, [hosts_list], config_version}` or
  `{:error, reason}`
  """
  def get_cluster_info(host, port \\ 11_211) do
    with {:ok, socket} <- @socket.connect(host, port, @timeout),
         {:ok, command} <- get_command(socket),
         {:ok, data} <- @socket.send_and_recv(socket, command, @timeout) do
      digest_cluster_data(data)
    end
  end

  defp digest_cluster_data(data) do
    values = String.split(data, "\n")
    case length(values) do
      6 ->
        config_version = Enum.at(values, 1)
        hosts =
          values
          |> Enum.at(2)
          |> String.split(" ")
        {:ok, get_hosts_list(hosts), config_version}
      _ -> {:error, "Not recognized response from endpoint"}
    end
  end

  defp get_hosts_list(hosts) do
    Enum.reduce(hosts, [], fn(x, acc) ->
      parts = String.split(x, "|")
      ["#{Enum.at(parts, 1)}:#{Enum.at(parts, 2)}" | acc]
    end)
  end

  # The command to execute is different depending on versions
  defp get_command(socket) do
    case get_version(socket) do
      {:ok, version} ->
        case Version.compare(version, "1.4.14") do
          :lt -> {:ok, "get AmazonElastiCache:cluster\n"}
          _   -> {:ok, "config get cluster\n"}
        end
      {:error, reason} -> {:error, reason}
    end
  end

  # Gets version number
  defp get_version(socket) do
    case @socket.send_and_recv(socket, "version\n", @timeout) do
      {:ok, data} ->
        <<"VERSION ", version :: binary >> = data
        {:ok, String.trim(version)}
      {:error, reason} -> {:error, reason}
    end
  end

end
