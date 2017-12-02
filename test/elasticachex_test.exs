defmodule ElasticachexTest do
  use ExUnit.Case
  doctest Elasticachex

  test "version > 1.4.14" do
    assert Elasticachex.get_cluster_info("version>1.4.14") ==
      {:ok, ["10.0.9.238:11211"], "1"}
  end

  test "version < 1.4.14" do
    assert Elasticachex.get_cluster_info("version<1.4.14") ==
      {:ok, ["10.0.9.238:11211"], "1"}
  end

  test "returns multiple nodes" do
    assert Elasticachex.get_cluster_info("multiple_nodes") ==
      {:ok, ["10.80.249.27:11211", "10.82.235.120:11211"], "12"}
  end
end
