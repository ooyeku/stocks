include("StockPrice.jl")
include("Ticker.jl")
include("Headlines.jl")

using .StockPrice
using .Ticker
using .Headlines
using Plots

using PlotlyJS

"""
    analyze_stock(ticker::String; 
                 range::String="1mo", 
                 interval::String="1d", 
                 sma_window::Int=10,
                 ema_window::Int=0,
                 plot_candlestick::Bool=false,
                 output_file::Union{String, Nothing}=nothing)

Analyze stock data for a single ticker with optional EMA and candlestick plot.

# Arguments
- `ticker::String`: Ticker symbol to analyze.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.
- `sma_window::Int=10`: Window size for SMA calculation.
- `ema_window::Int=0`: Window size for EMA calculation. Set to >0 to compute EMA.
- `plot_candlestick::Bool=false`: Whether to plot a candlestick chart.
- `output_file::Union{String, Nothing}=nothing`: Path to save the plot to. If `nothing`, the plot is displayed.

# Examples
```julia
# Analyze a stock with SMA
analyze_stock(Ticker.APPLE, sma_window=10)

# Analyze a stock with SMA and EMA
analyze_stock(Ticker.APPLE, sma_window=10, ema_window=20)

# Analyze a stock with SMA and EMA, and save to file
analyze_stock(Ticker.APPLE, sma_window=10, ema_window=20, output_file="apple_analysis.png")

# Analyze a stock with candlestick plot
analyze_stock(Ticker.APPLE, plot_candlestick=true)
```
"""
function analyze_stock(ticker::String; 
                      range::String="1mo", 
                      interval::String="1d", 
                      sma_window::Int=10,
                      ema_window::Int=0,
                      plot_candlestick::Bool=false,
                      output_file::Union{String, Nothing}=nothing)
    data = StockPrice.fetch_stock_data(ticker; range=range, interval=interval)
    
    if isempty(data)
        @warn "No data fetched for ticker '$ticker'. Skipping analysis."
        return
    end

    if plot_candlestick
        p_candle = StockPrice.plot_candlestick(data)
        if !isnothing(output_file)
            candlestick_file = replace(output_file, r"\.png$" => "_candlestick.png")
            savefig(p_candle, candlestick_file)
            println("Candlestick plot saved to: $candlestick_file")
        else
            display(p_candle)
        end
    end
    
    plot_data = StockPrice.plot_stock_data(data, sma_window)
    
    if ema_window > 0
        ema = StockPrice.compute_ema(data.close, ema_window)
        if !isempty(ema)
            dates_ema = data.timestamp[1:length(ema)]
            plot!(plot_data, dates_ema, ema, label="$(ema_window)d EMA")
        else
            @warn "EMA not computed for ticker '$ticker' due to insufficient data."
        end
    end
    
    if !isnothing(output_file)
        savefig(plot_data, output_file)
        println("Plot saved to: $output_file")
    else
        display(plot_data)
    end
end

"""
    analyze_stock(ticker::String, output_file::String; 
                 range::String="1mo", 
                 interval::String="1d", 
                 sma_window::Int=10,
                 ema_window::Int=0,
                 plot_candlestick::Bool=false)

Analyze stock data for a single ticker and save the plot to a file with optional EMA and candlestick plot.

# Arguments
- `ticker::String`: Ticker symbol to analyze.
- `output_file::String`: Path to save the plot to.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.
- `sma_window::Int=10`: Window size for SMA calculation.
- `ema_window::Int=0`: Window size for EMA calculation. Set to >0 to compute EMA.
- `plot_candlestick::Bool=false`: Whether to plot a candlestick chart.

# Examples
```julia
# Analyze a stock with SMA and save plot
analyze_stock(Ticker.APPLE, "apple_analysis.png", sma_window=10)

# Analyze a stock with SMA and EMA, and save plot
analyze_stock(Ticker.APPLE, "apple_analysis.png", sma_window=10, ema_window=20)

# Analyze a stock with candlestick plot and save both plots
analyze_stock(Ticker.APPLE, "apple_analysis.png", sma_window=10, plot_candlestick=true)
```
"""
function analyze_stock(ticker::String, output_file::String; 
                      range::String="1mo", 
                      interval::String="1d", 
                      sma_window::Int=10,
                      ema_window::Int=0,
                      plot_candlestick::Bool=false)
    data = StockPrice.fetch_stock_data(ticker; range=range, interval=interval)
    
    if isempty(data)
        @warn "No data fetched for ticker '$ticker'. Skipping analysis."
        return
    end

    if plot_candlestick
        p_candle = StockPrice.plot_candlestick(data)
        candlestick_file = replace(output_file, r"\.png$" => "_candlestick.png")
        savefig(p_candle, candlestick_file)
        println("Candlestick plot saved to: $candlestick_file")
    end
    
    plot_data = StockPrice.plot_stock_data(data, sma_window)
    
    if ema_window > 0
        ema = StockPrice.compute_ema(data.close, ema_window)
        if !isempty(ema)
            dates_ema = data.timestamp[1:length(ema)]
            plot!(plot_data, dates_ema, ema, label="$(ema_window)d EMA")
        else
            @warn "EMA not computed for ticker '$ticker' due to insufficient data."
        end
    end
    
    savefig(plot_data, output_file)
    println("Plot saved to: $output_file")
end

"""
    analyze_stocks(tickers::Vector{String}; 
                  range::String="1mo", 
                  interval::String="1d", 
                  sma_window::Int=10,
                  ema_window::Int=0,
                  plot_candlestick::Bool=false,
                  output_file::Union{String, Nothing}=nothing)

Analyze multiple tickers with optional SMA, EMA, and candlestick plots.

# Arguments
- `tickers::Vector{String}`: Vector of ticker symbols to analyze.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.
- `sma_window::Int=10`: Window size for SMA calculation.
- `ema_window::Int=0`: Window size for EMA calculation. Set to >0 to compute EMA.
- `plot_candlestick::Bool=false`: Whether to plot candlestick charts for each ticker.
- `output_file::Union{String, Nothing}=nothing`: Path prefix to save the plots to. If `nothing`, plots are displayed.

# Examples
```julia
# Analyze multiple stocks with SMA and display plots
analyze_stocks([Ticker.APPLE, Ticker.MICROSOFT], sma_window=10)

# Analyze multiple stocks with SMA and EMA, and save plots
analyze_stocks([Ticker.APPLE, Ticker.MICROSOFT], 
              sma_window=10, 
              ema_window=20, 
              output_file="tech_stocks_analysis.png")

# Analyze multiple stocks with candlestick plots
analyze_stocks([Ticker.APPLE, Ticker.MICROSOFT], plot_candlestick=true)
```
"""
function analyze_stocks(tickers::Vector{String}; 
                       range::String="1mo", 
                       interval::String="1d", 
                       sma_window::Int=10,
                       ema_window::Int=0,
                       plot_candlestick::Bool=false,
                       output_file::Union{String, Nothing}=nothing)
    data = StockPrice.fetch_stock_data(tickers; range=range, interval=interval)
    
    if isempty(data)
        @warn "No data fetched for the provided tickers. Skipping analysis."
        return
    end

    if plot_candlestick
        for ticker in unique(data.ticker)
            ticker_data = data[data.ticker .== ticker, :]
            if isempty(ticker_data)
                @warn "No data for ticker '$ticker'. Skipping candlestick plot."
                continue
            end
            p_candle = StockPrice.plot_candlestick(ticker_data)
            if !isnothing(output_file)
                candlestick_file = replace(output_file, r"\.png$" => "_$(ticker)_candlestick.png")
                savefig(p_candle, candlestick_file)
                println("Candlestick plot for $ticker saved to: $candlestick_file")
            else
                display(p_candle)
            end
        end
    end
    
    plot_data = StockPrice.plot_stock_data(data, sma_window)
    
    if ema_window > 0
        for ticker in unique(data.ticker)
            ticker_data = data[data.ticker .== ticker, :]
            ema = StockPrice.compute_ema(ticker_data.close, ema_window)
            if !isempty(ema)
                dates_ema = ticker_data.timestamp[1:length(ema)]
                plot!(plot_data, dates_ema, ema, label="$ticker $(ema_window)d EMA")
            else
                @warn "EMA not computed for ticker '$ticker' due to insufficient data."
            end
        end
    end
    
    if !isnothing(output_file)
        savefig(plot_data, output_file)
        println("Plot saved to: $output_file")
    else
        display(plot_data)
    end
end

"""
    analyze_stocks(tickers::Vector{String}, output_file::String; 
                  range::String="1mo", 
                  interval::String="1d", 
                  sma_window::Int=10,
                  ema_window::Int=0,
                  plot_candlestick::Bool=false)

Analyze multiple tickers and save the plots to a file with optional SMA, EMA, and candlestick plots.

# Arguments
- `tickers::Vector{String}`: Vector of ticker symbols to analyze.
- `output_file::String`: Path prefix to save the plots to.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.
- `sma_window::Int=10`: Window size for SMA calculation.
- `ema_window::Int=0`: Window size for EMA calculation. Set to >0 to compute EMA.
- `plot_candlestick::Bool=false`: Whether to plot candlestick charts for each ticker.

# Examples
```julia
# Analyze multiple stocks with SMA and save plots
analyze_stocks([Ticker.APPLE, Ticker.MICROSOFT], "tech_stocks_analysis.png", sma_window=10)

# Analyze multiple stocks with SMA and EMA, and save plots
analyze_stocks([Ticker.APPLE, Ticker.MICROSOFT], 
              "tech_stocks_analysis.png", 
              sma_window=10, 
              ema_window=20)

# Analyze multiple stocks with candlestick plots and save both plots
analyze_stocks([Ticker.APPLE, Ticker.MICROSOFT], 
              "tech_stocks_analysis.png", 
              sma_window=10, 
              plot_candlestick=true)
```
"""
function analyze_stocks(tickers::Vector{String}, output_file::String; 
                       range::String="1mo", 
                       interval::String="1d", 
                       sma_window::Int=10,
                       ema_window::Int=0,
                       plot_candlestick::Bool=false)
    data = StockPrice.fetch_stock_data(tickers; range=range, interval=interval)
    
    if isempty(data)
        @warn "No data fetched for the provided tickers. Skipping analysis."
        return
    end

    if plot_candlestick
        for ticker in unique(data.ticker)
            ticker_data = data[data.ticker .== ticker, :]
            if isempty(ticker_data)
                @warn "No data for ticker '$ticker'. Skipping candlestick plot."
                continue
            end
            p_candle = StockPrice.plot_candlestick(ticker_data)
            candlestick_file = replace(output_file, r"\.png$" => "_$(ticker)_candlestick.png")
            savefig(p_candle, candlestick_file)
            println("Candlestick plot for $ticker saved to: $candlestick_file")
        end
    end
    
    plot_data = StockPrice.plot_stock_data(data, sma_window)
    
    if ema_window > 0
        for ticker in unique(data.ticker)
            ticker_data = data[data.ticker .== ticker, :]
            ema = StockPrice.compute_ema(ticker_data.close, ema_window)
            if !isempty(ema)
                dates_ema = ticker_data.timestamp[1:length(ema)]
                plot!(plot_data, dates_ema, ema, label="$ticker $(ema_window)d EMA")
            else
                @warn "EMA not computed for ticker '$ticker' due to insufficient data."
            end
        end
    end
    
    savefig(plot_data, output_file)
    println("Plot saved to: $output_file")
end

function example_usage()
    begin
        println("Example 1: Analyze a single stock with SMA and display the plot")
        analyze_stock(Ticker.APPLE, range="6mo", interval="1d", sma_window=30)
    end
    begin
        println("\nExample 2: Analyze a single stock with SMA and EMA, and save the plot to a file")
        analyze_stock(Ticker.MICROSOFT, "microsoft_stock_analysis.png", range="6mo", interval="1d", sma_window=30, ema_window=50)
    end
    begin
        println("\nExample 3: Analyze multiple stocks with SMA and display the plot")
        analyze_stocks([Ticker.GOOGLE, Ticker.AMAZON], range="6mo", interval="1d", sma_window=30)
    end
    begin
        println("\nExample 4: Analyze multiple stocks with SMA and save the plot to a file")
        analyze_stocks([Ticker.SAP, Ticker.ORACLE, Ticker.SALESFORCE], "enterprise_software_analysis.png", range="6mo", interval="1d", sma_window=30)
    end
    begin
        # analyzing by industry
        println("\nExample 5: Analyze multiple stocks by industry with EMA")
        analyze_stocks(Ticker.TECH, range="6mo", interval="1d", sma_window=30, ema_window=50)
    end
    begin
        # Analyze with candlestick plots
        println("\nExample 6: Analyze a single stock with candlestick plot")
        analyze_stock(Ticker.TESLA, plot_candlestick=true)
    end
    begin
        # Analyze multiple stocks with candlestick plots and save plots
        println("\nExample 7: Analyze multiple stocks with candlestick plots and save to file")
        analyze_stocks([Ticker.APPLE, Ticker.MICROSOFT], "tech_stocks_analysis.png", plot_candlestick=true)
    end
    println("\nCheck the current directory for saved plot files.")
end