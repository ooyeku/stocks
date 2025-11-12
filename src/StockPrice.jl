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
    # Add ticker column safely even for empty dataframes
    data[!, :ticker] = fill(ticker, nrow(data))
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
    compute_sma(prices::AbstractVector{<:Real}, window_size::Int)

Compute simple moving average for a given price vector.

# Arguments
- `prices::AbstractVector{<:Real}`: Vector of prices to compute SMA for.
- `window_size::Int`: Window size for SMA calculation (> 0).

# Returns
- `Vector{<:Real}`: Vector of SMA values. If all averages are whole numbers and
  `prices` are integers, returns a Vector{Int}; otherwise returns Vector{Float64}.
"""
function compute_sma(prices::AbstractVector{<:Real}, window_size::Int)
    if window_size <= 0
        @warn "SMA window_size must be > 0. Got $window_size. Returning empty result."
        return Float64[]
    end
    n = length(prices)
    if n < window_size
        return Float64[]
    end
    # Compute as Float64 by default for numerical stability
    avgs = [mean(@view prices[i:i+window_size-1]) for i in 1:(n-window_size+1)]
    if eltype(prices) <: Integer && all(x -> x == round(x), avgs)
        return round.(Int, avgs)
    end
    return avgs
end

"""
    compute_ema(prices::AbstractVector{<:Real}, window::Int) -> Vector{Float64}

Compute the Exponential Moving Average (EMA) for a given window size.

# Arguments
- `prices::Vector{Float64}`: Vector of stock prices.
- `window::Int`: Number of periods for EMA calculation.

# Returns
- `Vector{Float64}`: Vector of EMA values.
"""
function compute_ema(prices::AbstractVector{<:Real}, window::Int)
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
    # ensure Float64 numeric values
    first_price = Float64(prices[1])
    push!(ema, first_price) # Initialize EMA with the first price
    @inbounds for i in 2:length(prices)
        price = Float64(prices[i])
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
        p = Plots.plot(dates, close_prices, label="Close", legend=:topleft, title="$ticker Stock Analysis", size=(800, 600))
        # Only plot SMA when there are enough points
        if length(close_prices) >= sma_window
            sma = compute_sma(close_prices, sma_window)
            Plots.plot!(p, dates[sma_window:end], sma, label="$(sma_window)d SMA")
        else
            @warn "Not enough data points to plot $(sma_window)d SMA for ticker '$ticker' (have $(length(close_prices)))."
        end
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