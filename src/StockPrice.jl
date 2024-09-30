module StockPrice

using YFinance
using Plots
using DataFrames
using Statistics
using PlotlyJS

export fetch_stock_data, compute_sma, compute_ema, plot_stock_data, plot_candlestick

"""
    fetch_stock_data(ticker::String; range::String="1mo", interval::String="1d")

Fetch stock data for a single ticker.

# Arguments
- `ticker::String`: Ticker symbol to fetch data for.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.

# Returns
- `DataFrame`: DataFrame containing stock data for the ticker.
"""
function fetch_stock_data(ticker::String; range::String="1mo", interval::String="1d")
    data = get_prices(ticker; range=range, interval=interval) |> DataFrame
    data[!, :ticker] .= ticker  
    return data
end

"""
    fetch_stock_data(tickers::Vector{String}; range::String="1mo", interval::String="1d")

Fetch stock data for multiple tickers.

# Arguments
- `tickers::Vector{String}`: Vector of ticker symbols to fetch data for.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.

# Returns
- `DataFrame`: DataFrame containing stock data for all tickers.
"""
function fetch_stock_data(tickers::Vector{String}; range::String="1mo", interval::String="1d")
    return vcat([fetch_stock_data(ticker; range=range, interval=interval) for ticker in tickers]...)
end

"""
    compute_sma(prices::Vector{<:Real}, window_size::Int)

Compute simple moving average for a given price vector.

# Arguments
- `prices::Vector{<:Real}`: Vector of prices to compute SMA for.
- `window_size::Int`: Window size for SMA calculation.

# Returns
- `Vector{<:Real}`: Vector of SMA values.
"""
function compute_sma(prices::Vector{<:Real}, window_size::Int)
    return [mean(prices[i:i+window_size-1]) for i in 1:(length(prices)-window_size+1)]
end

"""
    compute_ema(prices::Vector{Float64}, window::Int) -> Vector{Float64}

Compute the Exponential Moving Average (EMA) for a given window size.

# Arguments
- `prices::Vector{Float64}`: Vector of stock prices.
- `window::Int`: Number of periods for EMA calculation.

# Returns
- `Vector{Float64}`: Vector of EMA values.
"""
function compute_ema(prices::Vector{Float64}, window::Int)
    if isempty(prices)
        @warn "compute_ema called with an empty prices vector."
        return Float64[]
    end
    if window <= 0
        @error "Window size for EMA must be greater than 0."
        return Float64[]
    end
    if length(prices) < window
        @warn "Not enough data points to compute EMA. Required: $window, Provided: $(length(prices))"
        return Float64[]
    end
    
    α = 2 / (window + 1)
    ema = Float64[]
    push!(ema, prices[1]) # Initialize EMA with the first price
    for price in prices[2:end]
        push!(ema, α * price + (1 - α) * ema[end])
    end
    return ema
end

"""
    plot_stock_data(data::DataFrame, sma_window::Int)

Plot stock data for a single ticker.

# Arguments
- `data::DataFrame`: DataFrame containing stock data for the ticker.
- `sma_window::Int`: Window size for SMA calculation.

# Returns
- `Plot`: Plot of the stock data.
"""
function plot_stock_data(data::DataFrame, sma_window::Int)
    plots = []
    for ticker in unique(data[!, :ticker])
        ticker_data = data[data[!, :ticker] .== ticker, :]
        dates = ticker_data[!, :timestamp]
        close_prices = ticker_data[!, :close]
        sma = compute_sma(close_prices, sma_window)
        
        p = Plots.plot(dates, close_prices, label="Close", legend=:topleft, title="$ticker Stock Analysis", size=(800, 600))
        Plots.plot!(p, dates[sma_window:end], sma, label="$(sma_window)d SMA")
        push!(plots, p)
    end
    return Plots.plot(plots..., layout=(length(plots), 1), size=(800, 600 * length(plots)))
end

"""
    plot_candlestick(data::DataFrame)

Plot a candlestick chart for the given stock data.

# Arguments
- `data::DataFrame`: DataFrame containing stock data with columns :timestamp, :open, :high, :low, :close.
"""
function plot_candlestick(data::DataFrame)
    trace = PlotlyJS.candlestick(;
        x=data.timestamp,
        open=data.open,
        high=data.high,
        low=data.low,
        close=data.close
    )
    layout = PlotlyJS.Layout(title="Candlestick Chart", xaxis_title="Date", yaxis_title="Price")
    fig = PlotlyJS.plot(trace, layout)
    PlotlyJS.display(fig)
    return fig
end

end # module