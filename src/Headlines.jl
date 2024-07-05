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


end
