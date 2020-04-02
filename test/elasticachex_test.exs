defmodule ElasticachexTest do
  use ExUnit.Case
  doctest Elasticachex

  test "version > 1.4.14" do
    assert Elasticachex.get_cluster_info("version>1.4.14") ==
      {:ok, ["memcached-cluster.xlttkm.0001.euw1.cache.amazonaws.com:11211"], "1"}
  end

  test "version < 1.4.14" do
    assert Elasticachex.get_cluster_info("version<1.4.14") ==
      {:ok, ["memcached-cluster.xlttkm.0001.euw1.cache.amazonaws.com:11211"], "1"}
  end

  test "returns multiple nodes" do
    assert Elasticachex.get_cluster_info("multiple_nodes") ==
      {:ok, ["myCluster.pc4ldq.0002.use1.cache.amazonaws.com:11211", "myCluster.pc4ldq.0001.use1.cache.amazonaws.com:11211"], "12"}
  end
end
