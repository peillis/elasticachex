# Elasticachex

[![Build Status](https://secure.travis-ci.org/peillis/elasticachex.svg)](http://travis-ci.org/peillis/elasticachex)

An implementation of the Node Auto Discovery for Memcached in the
ElastiCache service of AWS.

See http://docs.aws.amazon.com/AmazonElastiCache/latest/UserGuide/AutoDiscovery.html

## Example

    iex> Elasticachex.get_cluster_info("hostname.aws.com")
    {:ok, ["10.0.9.107:11211", "10.0.9.109:11211"], "4"}


## Installation

The package can be installed by adding `elasticachex` to your list of
dependencies in `mix.exs`:

```elixir
def deps do
  [{:elasticachex, "~> 1.0"}]
end
```
