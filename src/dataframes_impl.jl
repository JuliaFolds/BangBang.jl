_getvalue(x, pos, name) = getproperty(x, name)
_getvalue(x::AbstractVector, pos, name) = x[pos]
_getvalue(x::Tuple, pos, name) = x[pos]
_getvalue(x::NamedTuple, pos, name) = x[name]
_getvalue(x::AbstractDict, pos, name) = x[name]

_hascolumn(x, n) = hasproperty(x, n)
_hascolumn(::NamedTuple{names}, n) where {names} = n in names  # optimization
_hascolumn(x::AbstractDict, n) = haskey(x, n)

function checkcolumnnames(x, columnnames)
    for n in columnnames
        _hascolumn(x, n) || error("No column `", n, "` in given row.")
    end
    length(columnnames) < length(x) && error("More columns exist in given row.")
    @assert length(columnnames) == length(x)
end

function checkcolumnnames(x::Union{Tuple,AbstractVector}, columnnames)
    length(columnnames) == length(x) || error("Number of columns does not match.")
end

function df_append_columns!!(df, table)
    columns = getfield(df, :columns)
    colnames = DataFrames._names(df)  # avoid copy
    checkcolumnnames(columns, colnames)
    for (pos, (name, col)) in enumerate(zip(colnames, columns))
        columns[pos] = append!!(col, _getvalue(table, pos, name))
    end
    return df
end

macro manually_specialize(expr, head, tail...)
    Expr(:if, head, expr, manually_specialize_impl(expr, tail)) |> esc
end

manually_specialize_impl(expr, predicates) =
    if isempty(predicates)
        expr
    else
        Expr(
            :elseif,
            predicates[1],
            expr,
            manually_specialize_impl(expr, predicates[2:end]),
        )
    end

function df_append_rows!!(df, table)
    columns = getfield(df, :columns)
    colnames = DataFrames._names(df)  # avoid copy
    # colnames = propertynames(df)
    for x in table
        checkcolumnnames(x, colnames)
        for (pos, (name, col)) in enumerate(zip(colnames, columns))
            v = _getvalue(x, pos, name)
            @manually_specialize(
                columns[pos] = push!!(col, v),
                # "Inline" some method lookups for typical column types:
                col isa Vector{Int},
                col isa Vector{Union{Int,Missing}},
                col isa Vector{Float64},
                col isa Vector{Union{Float64,Missing}},
                col isa Vector{Symbol},
                col isa Vector{Union{Symbol,Missing}},
                col isa Vector{String},
                col isa Vector{Union{String,Missing}},
            )
        end
    end
    return df
end

df_append!!(df, table) =
    if Tables.columnaccess(table)
        df_append_columns!!(df, Tables.columns(table))
    elseif Tables.rowaccess(table)
        df_append_rows!!(df, Tables.rows(table))
    else
        df_append_rows!!(df, table)
    end
