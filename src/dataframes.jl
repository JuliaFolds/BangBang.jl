push!!(df::DataFrames.DataFrame, row) = df_append_rows!!(df, (row,))
append!!(df::DataFrames.DataFrame, source) = df_append!!(df, source)
copyappendable(df::DataFrames.AbstractDataFrame) = copy(df)
