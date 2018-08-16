defmodule Elasticachex.SocketTest do

  def connect("version>1.4.14", _port, _timeout) do
    {:ok, :socket_1}
  end
  def connect("version<1.4.14", _port, _timeout) do
    {:ok, :socket_2}
  end
  def connect("multiple_nodes", _port, _timeout) do
    {:ok, :multiple_nodes}
  end

  def close(_), do: :ok

  def send_and_recv(:socket_1, command, _timeout) do
    case command do
      "version\n" -> {:ok, "VERSION 1.4.14\r\n"}
      "config get cluster\n" -> {:ok, "CONFIG cluster 0 74\r\n1\nmemcached-cluster.xlttkm.0001.euw1.cache.amazonaws.com|10.0.9.238|11211\n\r\nEND\r\n"}
    end
  end
  def send_and_recv(:socket_2, command, _timeout) do
    case command do
      "version\n" -> {:ok, "VERSION 1.4.13\r\n"}
      "get AmazonElastiCache:cluster\n" -> {:ok, "CONFIG cluster 0 74\r\n1\nmemcached-cluster.xlttkm.0001.euw1.cache.amazonaws.com|10.0.9.238|11211\n\r\nEND\r\n"}
    end
  end
  def send_and_recv(:multiple_nodes, command, _timeout) do
    case command do
      "version\n" -> {:ok, "VERSION 1.4.14\r\n"}
      "config get cluster\n" -> {:ok, "CONFIG cluster 0 147\r\n12\nmyCluster.pc4ldq.0001.use1.cache.amazonaws.com|10.82.235.120|11211 myCluster.pc4ldq.0002.use1.cache.amazonaws.com|10.80.249.27|11211\n\r\nEND\r\n"}
    end
  end

end
