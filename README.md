# Sll

iex -S mix

{:ok, pid} = Sll.Application.start()

Sll.Fetcher.all_fixtures_by_date()
