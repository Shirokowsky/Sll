defmodule Sll.Application do
  @moduledoc false

  use Application

  def start() do
    children = [
      Sll.Fetcher,
      { ConCache, [name: :games, ttl_check_interval: :timer.hours(5), global_ttl: :timer.hours(5)] },
    ]

    opts = [
      strategy: :one_for_one,
      name: Sll.Supervisor
    ]

    Supervisor.start_link(children, opts)
  end
end
