module Headlines
include("Ticker.jl")

using YFinance
using Dates
using DataFrames
using .Ticker

mutable struct NewsItem
    title::String
    publisher::String
    link::String
    timestamp::DateTime
    symbols::Vector{String}
end

"""
    get_headlines(symbol::String)

Get the headlines for a given symbol.

    Arguments
        symbol::String - The symbol to get the headlines for.

    Returns
        headlines::Vector{NewsItem} - A vector of news items.
"""
function get_headlines(symbol::String)
    news = search_news(symbol)
    return news
end

"""
    get_headlines(symbols::Vector{String})

Get the headlines for a given vector of symbols.

    Arguments
        symbols::Vector{String} - A vector of symbols to get the headlines for.

    Returns
        headlines::Vector{NewsItem} - A vector of news items.
"""
function get_headlines(symbols::Vector{String})
    headlines = []
    for symbol in symbols
        news = get_headlines(symbol)
        for item in news
            headlines = push!(headlines, item)
        end
    end
    return headlines
end

"""
    get_titles(symbol::String)

Get the titles for a given symbol.

    Arguments
        symbol::String - The symbol to get the titles for.

    Returns
        titles::Vector{String} - A vector of titles.
"""
function get_titles(symbol::String)
    return get_headlines(symbol) |> titles
end

"""
    get_titles(symbols::Vector{String})

Get the titles for a given vector of symbols.

    Arguments
        symbols::Vector{String} - A vector of symbols to get the titles for.

    Returns
        titles::Vector{String} - A vector of titles.

    Example
        get_titles(Ticker.TECH)
        or 
        get_titles([Ticker.MICROSOFT, Ticker.APPLE])
"""
function get_titles(symbols::Vector{String})
    titles = []
    for symbol in symbols
        titles = append!(titles, get_titles(symbol))
    end
    return titles
end

"""
    get_headlines_dataframe(symbol::String)

Get the headlines for a given symbol.

    Arguments
        symbol::String - The symbol to get the headlines for.

    Returns
        headlines::DataFrame - A dataframe of headlines.
"""
function get_headlines_dataframe(symbol::String)
    headlines = get_headlines(symbol)
    return DataFrame(headlines)
end

"""
    get_headlines_dataframe(symbols::Vector{String})

Get the headlines for a given vector of symbols.

    Arguments
        symbols::Vector{String} - A vector of symbols to get the headlines for.

    Returns
        headlines::DataFrame - A dataframe of headlines.
"""
function get_headlines_dataframe(symbols::Vector{String})
    headlines = get_headlines(symbols)
    return DataFrame(headlines)
end

"""
    compute_sentiment(headlines::DataFrame) -> DataFrame

Compute sentiment scores for each headline.

# Arguments
- `headlines::DataFrame`: DataFrame with a :title column containing headlines.
"""
function compute_sentiment(headlines::DataFrame)
    # Placeholder: Replace with actual sentiment analysis
    headlines.sentiment = rand([-1, 0, 1], nrow(headlines))
    return headlines
end

end
