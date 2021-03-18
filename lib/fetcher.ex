defmodule Sll.Fetcher do
  use GenServer

  def start_link([]) do
    GenServer.start_link(__MODULE__, [], name: :fetcher)
  end

  def all_fixtures_by_date(req_date \\ "2018-08-11") do
    GenServer.call(:fetcher, {:fixture_all, req_date})
  end

  def next_fix_by_team(tId) do
    GenServer.call(:fetcher, {:next_fix_by_team, tId})
  end

  def team_stat_by_fid(fId) do
    GenServer.call(:fetcher, {:team_stat, fId})
  end

  def fix_end(fId) do
    GenServer.call(:fetcher, {:fix_end, fId})
  end

  # SERVER / callbacks

  def init(state) do
    {:ok, state}
  end

  def handle_call({:fixture_all, req_date}, _from, state) do
    data = fixtures_cache(req_date)
    {:reply, data, state}
  end

  def handle_call({:next_fix_by_team, tId}, _from, state) do
    data = next_by_team_cache(tId)
    {:reply, data, state}
  end

  def handle_call({:team_stat, fId}, _from, state) do
    data = team_stat_cache(fId)
    {:reply, data, state}
  end

  def handle_call({:fix_end, fId}, _from, state) do
    data = fix_end_cache(fId)
    {:reply, data, state}
  end

  defp fixtures_cache(requested_date) do
    ConCache.get_or_store(:games, "fixtures_" <> requested_date, fn() ->
      {:ok, resp} = Sll.HttpoisonParams.get("fixtures?date=" <> requested_date, :new_api)
      resp.body |> Poison.decode!()
    end)
  end

  defp next_by_team_cache(tId) do
    id = Integer.to_string(tId)
    ConCache.get_or_store(:games, "next_by_team_" <> id, fn() ->
      {:ok, resp} = Sll.HttpoisonParams.get("fixtures/team/" <> id <> "/next/10")
      resp.body |> Poison.decode!()
    end)
  end

  defp team_stat_cache(fId) do
    id = Integer.to_string(fId)
    ConCache.get_or_store(:games, "team_stat_" <> id, fn() ->
      {:ok, resp} = Sll.HttpoisonParams.get("fixtures?date=" <> id, :new_api)
      resp.body |> Poison.decode!()
    end)
  end

  defp fix_end_cache(fId) do
    ConCache.get_or_store(:games, "fix_end_" <> fId, fn() ->
      {:ok, resp} = Sll.HttpoisonParams.get("fixtures?date=" <> fId, :new_api)
      resp.body |> Poison.decode!()
    end)
  end
end
