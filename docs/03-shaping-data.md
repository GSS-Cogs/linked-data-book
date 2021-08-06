# Creating Linked Data

## Tidy(ish) data {#tidy-data}

> TODO:
>
> https://r4ds.had.co.nz/tidy-data.html
>
> Some sort of `unpivotr` example going from a spreadsheet to tidy data.

### Dates and times

> TODO:
>
> Explain [reference.data.gov.uk](https://github.com/epimorphics/IntervalServer/blob/master/interval-uris.md)] in a friendly way.
>
> Do we separate out months vs. years vs. quarters?

### UK geographies

> TODO: Explain statistics.data.gov.uk in a friendly way.

### Multiple Measures

> TODO: Explain how to pivot a wide, multiple measure dataframe into a long, measure-dimension dataframe.

### Hierarchies

> TODO: What do you do when you have a parent -> child relationship in the dataset. We need to make explicit that columns should be orthogonal from one another.

### Statistical Markers

> TODO: How to deal with missing values, or marks which indicate non-disclosure etc.

### Cubes

> TODO: Explain how to create a cube from a dataframe.
>
> - Dimensions.
> - Measures.
> - Attributes.


```r
ld_dataset(df,
    title = "My Dataset",
    description = "This is a description of the dataset",
    columns = ld_spec(
        period = dimension(),
        country = dimension(),
        value = measure()
    )
)
```

## CSV on the Web (CSVW)

> TODO: Explain the CSV on the Web (CSVW) format.
