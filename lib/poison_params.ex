defmodule Sll.HttpoisonParams do
  def get(url) do
    actual_url = "https://api-football-v1.p.rapidapi.com/v2/" <> url
    actual_get(actual_url)
  end

  def get(url, _) do
    actual_url = "https://api-football-v1.p.rapidapi.com/v3/" <> url
    actual_get(actual_url)
  end

  defp actual_get(actual_url) do
    token = '4c1eda6ff1mshf35ea9f4de42bfap164c55jsnb18505325558'
    host = 'api-football-v1.p.rapidapi.com'
    headers = [
      "x-rapidapi-key": token,
      "x-rapid-api-host": host,
      "Accept": "Application/json; Charset=utf-8"
      ]
    options = [ssl: [{:versions, [:'tlsv1.2']}], recv_timeout: 5000]
    HTTPoison.get(actual_url, headers, options)
  end
end

