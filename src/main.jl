include("StockPrice.jl")
include("Ticker.jl")

using .StockPrice
using .Ticker
using Plots

"""
    analyze_stock(ticker::String; range::String="1mo", interval::String="1d", sma_window::Int=10)

Analyze stock data for a single ticker.

# Arguments
- `ticker::String`: Ticker symbol to analyze.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.
- `sma_window::Int=10`: Window size for SMA calculation.
"""
function analyze_stock(ticker::String; range::String="1mo", interval::String="1d", sma_window::Int=10)
    data = StockPrice.fetch_stock_data(ticker; range=range, interval=interval)
    plot = StockPrice.plot_stock_data(data, sma_window)
    display(plot)
end

"""
    analyze_stock(ticker::String, output_file::String; range::String="1mo", interval::String="1d", sma_window::Int=10)

Analyze stock data for a single ticker and save the plot to a file.

# Arguments
- `ticker::String`: Ticker symbol to analyze.
- `output_file::String`: Path to save the plot to.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.
- `sma_window::Int=10`: Window size for SMA calculation.
"""
function analyze_stock(ticker::String, output_file::String; range::String="1mo", interval::String="1d", sma_window::Int=10)
    data = StockPrice.fetch_stock_data(ticker; range=range, interval=interval)
    plot = StockPrice.plot_stock_data(data, sma_window)
    savefig(plot, output_file)
    println("Plot saved to: $output_file")
end

"""
    analyze_stock(tickers::Vector{String}; range::String="1mo", interval::String="1d", sma_window::Int=10)

Analyze stock data for multiple tickers.

# Arguments
- `tickers::Vector{String}`: Vector of ticker symbols to analyze.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.
- `sma_window::Int=10`: Window size for SMA calculation.
"""
function analyze_stock(tickers::Vector{String}; range::String="1mo", interval::String="1d", sma_window::Int=10)
    data = StockPrice.fetch_stock_data(tickers; range=range, interval=interval)
    plot = StockPrice.plot_stock_data(data, sma_window)
    display(plot)
end

"""
    analyze_stock(tickers::Vector{String}, output_file::String; range::String="1mo", interval::String="1d", sma_window::Int=10)

Analyze stock data for multiple tickers and save the plot to a file.

# Arguments
- `tickers::Vector{String}`: Vector of ticker symbols to analyze.
- `output_file::String`: Path to save the plot to.
- `range::String="1mo"`: Time range for fetching data.
- `interval::String="1d"`: Interval for fetching data.
- `sma_window::Int=10`: Window size for SMA calculation.
"""
function analyze_stock(tickers::Vector{String}, output_file::String; range::String="1mo", interval::String="1d", sma_window::Int=10)
    data = StockPrice.fetch_stock_data(tickers; range=range, interval=interval)
    plot = StockPrice.plot_stock_data(data, sma_window)
    savefig(plot, output_file)
    println("Plot saved to: $output_file")
end

function example_usage()
    begin
        println("Example 1: Analyze a single stock and display the plot")
        analyze_stock(Ticker.APPLE, range="6mo", interval="1d", sma_window=30)
    end

    begin
        println("\nExample 2: Analyze a single stock and save the plot to a file")
        analyze_stock(Ticker.MICROSOFT, "microsoft_stock_analysis.png", range="6mo", interval="1d", sma_window=30)
    end

    begin
        println("\nExample 3: Analyze multiple stocks and display the plot")
        analyze_stock([Ticker.GOOGLE, Ticker.AMAZON], range="6mo", interval="1d", sma_window=30)
    end

    begin
        println("\nExample 4: Analyze multiple stocks and save the plot to a file")
        analyze_stock([Ticker.SAP, Ticker.ORACLE, Ticker.SALESFORCE], "enterprise_software_analysis.png", range="6mo", interval="1d", sma_window=30)
    end

    begin
        # analyzing by industry
        println("\nExample 5: Analyze multiple stocks by industry")
        analyze_stock(Ticker.TECH, range="6mo", interval="1d", sma_window=30)
    end

    println("\nCheck the current directory for saved plot files.")
end
