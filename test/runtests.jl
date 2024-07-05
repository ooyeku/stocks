using Test
using YFinance
using DataFrames

# Test if data fetching works
ticker = "AAPL"
data = get_prices(ticker, range="1mo", interval="1d") |> DataFrame

@test !isempty(data[!, :timestamp])
@test !isempty(data[!, :close])


test_prices = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
expected_sma_5 = [3, 4, 5, 6, 7, 8]
@test StockPrice.compute_sma(test_prices, 5) == expected_sma_5