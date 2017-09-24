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
end
