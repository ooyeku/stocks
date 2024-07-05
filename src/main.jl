include("StockPrice.jl")
using .StockPrice
using Plots

function analyze_stock(ticker::String; range::String="1mo", interval::String="1d", sma_window::Int=10)
    data = StockPrice.fetch_stock_data(ticker; range=range, interval=interval)
    plot = StockPrice.plot_stock_data(data, sma_window)
    display(plot)
end

function analyze_stock(ticker::String, output_file::String; range::String="1mo", interval::String="1d", sma_window::Int=10)
    data = StockPrice.fetch_stock_data(ticker; range=range, interval=interval)
    plot = StockPrice.plot_stock_data(data, sma_window)
    savefig(plot, output_file)
    println("Plot saved to: $output_file")
end

function example_usage()
    analyze_stock("SAP", "sap_stock_analysis.png", range="6mo", interval="1d", sma_window=30)
    analyze_stock("MSFT", "microsoft_stock_analysis.png", range="6mo", interval="1d", sma_window=30)
end
