_getvalue(x, pos, name) = getproperty(x, name)
_getvalue(x::AbstractVector, pos, name) = x[pos]
_getvalue(x::Tuple, pos, name) = x[pos]
_getvalue(x::AbstractDict, pos, name) = x[name]

_hascolumn(x, n) = hasproperty(x, n)
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

function df_append_rows!!(df, rows)
    columns = getfield(df, :columns)
    for x in rows
        checkcolumnnames(x, propertynames(df))
        for (pos, (name, col)) in enumerate(zip(propertynames(df), columns))
            v = _getvalue(x, pos, name)
            columns[pos] = push!!(col, v)
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
