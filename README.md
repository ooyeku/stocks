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

Analyze a single stock with a 6-month range, 1-day interval, and a 30-day SMA:
```julia
julia> analyze_stock(Ticker.APPLE, range="6mo", interval="1d", sma_window=30)
```

Analyze a single stock with SMA, EMA, and save the plot to a file:
```julia
julia> analyze_stock(Ticker.MICROSOFT, "microsoft_stock_analysis.png", range="6mo", interval="1d", sma_window=30, ema_window=50)
```

Analyze multiple stocks with SMA:
```julia
julia> analyze_stocks([Ticker.GOOGLE, Ticker.AMAZON], range="6mo", interval="1d", sma_window=30)
```

Analyze multiple stocks by industry with EMA:
```julia
julia> analyze_stocks(Ticker.TECH, range="6mo", interval="1d", sma_window=30, ema_window=50)
```

Analyze a single stock with a candlestick plot:
```julia
julia> analyze_stock(Ticker.TESLA, plot_candlestick=true)
```

Analyze multiple stocks with candlestick plots and save to file:
```julia
julia> analyze_stocks([Ticker.APPLE, Ticker.MICROSOFT], "tech_stocks_analysis.png", plot_candlestick=true)
```

Fetch news for a given ticker:
```julia
julia> news = get_headlines(Ticker.TESLA)
```

Fetch news for a group of tickers:
```julia
julia> news = get_headlines(Ticker.TECH)
```

The `get_headlines` function returns a vector of NewsItem objects, which contain the title, link, and date of the news item.

The `get_headlines_dataframe` function returns a dataframe of the headlines for convenience:
```julia
julia> news = get_headlines_dataframe(Ticker.TECH)
```