# Julia Stock Analysis

This project demonstrates how to analyze stock market trends using Julia and the [YFinance.jl](https://github.com/sygwer/YFinance.jl) package. The main script fetches stock data for a given ticker, computes a simple moving average, and plots the results.

## Getting Started

Install the dependencies from the Julia REPL:
```julia
julia> using Pkg; Pkg.instantiate()
```

Run the main script:
```julia
julia> include("src/main.jl")
```
This will include the Headlines, StockPrice, and Ticker modules.  

## Examples

Analyze a single stock with a 1 month range, 1 day interval, and a 10 day SMA:
```julia
julia> tesla = analyze_stock(Ticker.TESLA, range="1mo", interval="1d", sma_window=10)
```

Analyze a group of stocks (predefined sectors):
```julia
julia> tech_stocks = analyze_stocks(Ticker.TECH, range="1mo", interval="1d", sma_window=10)
```

Save the plots to a file:
```julia
julia> tesla = analyze_stock(Ticker.TESLA, "tesla.png", range="1mo", interval="1d", sma_window=10)
```


Fetch news for a given ticker:
```julia
julia> news = get_headlines(Ticker.TESLA)
```

Alternatively, fetch news for a group of tickers:
```julia
julia> news = get_headlines(Ticker.TECH)
```

The `get_headlines` function returns a vector of NewsItem objects, which contain the title, link, and date of the news item.

The `get_headlines_dataframe` function returns a dataframe of the headlines for convenience.
```julia
julia> news = get_headlines_dataframe(Ticker.TECH)
```

