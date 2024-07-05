# Copyright 2024 olayeku
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     https://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
module StockPrice

using YFinance
using Plots
using DataFrames
using Statistics


const MICROSOFT = "MSFT"
const APPLE = "AAPL"
const GOOGLE = "GOOGL"
const TESLA = "TSLA"
const ORACLE = "ORCL"
const IBM = "IBM"
const META = "META"
const SAP = "SAP"
const WORKDAY = "WDAY"
const SALESFORCE = "CRM"
const NETFLIX = "NFLX"


export fetch_stock_data, compute_sma, plot_stock_data

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
    plot_stock_data(data::DataFrame, sma_window::Int)

Plot stock data for a single ticker.

# Arguments
- `data::DataFrame`: DataFrame containing stock data for the ticker.
- `sma_window::Int`: Window size for SMA calculation.

# Returns
- `Plot`: Plot of the stock data.
"""
function plot_stock_data(data::DataFrame, sma_window::Int)
    dates = data[!, :timestamp]
    close_prices = data[!, :close]
    sma = compute_sma(close_prices, sma_window)

    ticker = data[1, :ticker]
    title = "$(ticker) Stock Analysis"

    plot(dates, close_prices, label="Close", legend=:topleft, title=title, size=(800, 600))
    plot!(dates[sma_window:end], sma, label="$(sma_window)d SMA")
    
    return current()
end

"""
    plot_stock_data(data::DataFrame, sma_window::Int)

Plot stock data for multiple tickers.

# Arguments
- `data::DataFrame`: DataFrame containing stock data for all tickers.
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
        
        p = plot(dates, close_prices, label="Close", legend=:topleft, title="$ticker Stock Analysis", size=(800, 600))
        plot!(p, dates[sma_window:end], sma, label="$(sma_window)d SMA")
        push!(plots, p)
    end
    return plot(plots..., layout=(length(plots), 1), size=(800, 600 * length(plots)))
end

end # module
