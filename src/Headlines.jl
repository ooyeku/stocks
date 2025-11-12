module Headlines
include("Ticker.jl")

using YFinance
using Dates
using DataFrames
using .Ticker

export get_headlines, get_titles, get_headlines_dataframe, compute_sentiment

"""
Internal: get the first available field value from a mix of property or index keys
without eagerly evaluating defaults. Accepts Symbols or Strings as keys.
"""
function _get_field(x, keys)
    for k in keys
        v = try
            if k isa Symbol
                hasproperty(x, k) ? getproperty(x, k) : missing
            else
                haskey(x, k) ? getindex(x, k) : missing
            end
        catch
            missing
        end
        if v !== missing
            return v
        end
    end
    return missing
end

# Internal: normalize raw news item from YFinance.search_news into a NamedTuple
function _ni(x)
    title = _get_field(x, (:title, "title"))
    publisher = _get_field(x, (:publisher, "publisher"))
    link = _get_field(x, (:link, "link", :url, "url"))
    ts_raw = _get_field(x, (:timestamp, "timestamp", :providerPublishTime, "providerPublishTime"))
    ts = ts_raw
    if ts_raw isa AbstractString
        ts = try
            DateTime(ts_raw)
        catch
            missing
        end
    elseif ts_raw isa Real
        # Assume epoch seconds
        try
            ts = Dates.unix2datetime(ts_raw)
        catch
            ts = missing
        end
    end
    syms = _get_field(x, (:symbols, "symbols", :relatedTickers, "relatedTickers"))
    if syms === missing
        syms = String[]
    elseif syms isa AbstractVector
        syms = string.(syms)
    else
        syms = [string(syms)]
    end
    return (title=title, publisher=publisher, link=link, timestamp=ts, symbols=syms)
end

"""
    get_headlines(symbol::String)

Get the headlines for a given symbol.

Arguments
- symbol::String - The symbol to get the headlines for.

Returns
- Vector of normalized news items (NamedTuples).
"""
function get_headlines(symbol::String)
    raw = try
        YFinance.search_news(symbol)
    catch e
        @warn "Failed to fetch news for $symbol: $e"
        Any[]
    end
    return [_ni(item) for item in raw]
end

"""
    get_headlines(symbols::Vector{String})

Get the headlines for a given vector of symbols.

Arguments
- symbols::Vector{String}

Returns
- Vector of normalized news items (NamedTuples).
"""
function get_headlines(symbols::Vector{String})
    items = Any[]
    for sym in symbols
        append!(items, get_headlines(sym))
    end
    return items
end

"""
    get_titles(symbol::String)

Get the titles for a given symbol.
"""
function get_titles(symbol::String)
    return [it.title for it in get_headlines(symbol) if hasproperty(it, :title) && !ismissing(it.title)]
end

"""
    get_titles(symbols::Vector{String})

Get the titles for a given vector of symbols.
"""
function get_titles(symbols::Vector{String})
    ttl = String[]
    for sym in symbols
        append!(ttl, get_titles(sym))
    end
    return ttl
end

"""
    get_headlines_dataframe(symbol::String)

Get the headlines for a given symbol as a DataFrame with columns
:title, :publisher, :link, :timestamp, :symbols.
"""
function get_headlines_dataframe(symbol::String)
    items = get_headlines(symbol)
    return DataFrame(items)
end

"""
    get_headlines_dataframe(symbols::Vector{String})

Get the headlines for a given vector of symbols as a DataFrame.
"""
function get_headlines_dataframe(symbols::Vector{String})
    items = get_headlines(symbols)
    return DataFrame(items)
end

"""
    compute_sentiment(headlines::DataFrame) -> DataFrame

Compute sentiment scores for each headline (placeholder).
"""
function compute_sentiment(headlines::DataFrame)
    headlines[!, :sentiment] = rand([-1, 0, 1], nrow(headlines))
    return headlines
end

end
