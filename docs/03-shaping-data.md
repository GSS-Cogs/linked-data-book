# Creating linked data

## Tidy(ish) data {#tidy-data}

> TODO:
>
> https://r4ds.had.co.nz/tidy-data.html
>
> Some sort of `unpivotr` example going from a spreadsheet to tidy data.


```r
library(dplyr, warn.conflicts = FALSE)
library(tidyr)

set.seed(1) # Used to control randomness in the examples

df <- tibble(
        geography = c("W92000001", "E92000001"),
        `2015` = rnorm(2),
        `2016` = rnorm(2),
        `2017` = rnorm(2),
        `2018` = rnorm(2),
        `2019` = rnorm(2),
        `2020` = rnorm(2),
        `2021` = rnorm(2)
    )

df
#> [90m# A tibble: 2 × 8[39m
#>   [1mgeography[22m [1m`2015`[22m [1m`2016`[22m [1m`2017`[22m [1m`2018`[22m [1m`2019`[22m [1m`2020`[22m [1m`2021`[22m
#>   [3m[90m<chr>[39m[23m      [3m[90m<dbl>[39m[23m  [3m[90m<dbl>[39m[23m  [3m[90m<dbl>[39m[23m  [3m[90m<dbl>[39m[23m  [3m[90m<dbl>[39m[23m  [3m[90m<dbl>[39m[23m  [3m[90m<dbl>[39m[23m
#> [90m1[39m W92000001 -[31m0[39m[31m.[39m[31m626[39m -[31m0[39m[31m.[39m[31m836[39m  0.330  0.487  0.576  1.51  -[31m0[39m[31m.[39m[31m621[39m
#> [90m2[39m E92000001  0.184  1.60  -[31m0[39m[31m.[39m[31m820[39m  0.738 -[31m0[39m[31m.[39m[31m305[39m  0.390 -[31m2[39m[31m.[39m[31m21[39m
```


```r
df %>% pivot_longer(
    cols = !geography,
    names_to = "year",
    names_transform = list(year = as.numeric)
)
#> [90m# A tibble: 14 × 3[39m
#>   [1mgeography[22m  [1myear[22m  [1mvalue[22m
#>   [3m[90m<chr>[39m[23m     [3m[90m<dbl>[39m[23m  [3m[90m<dbl>[39m[23m
#> [90m1[39m W92000001  [4m2[24m015 -[31m0[39m[31m.[39m[31m626[39m
#> [90m2[39m W92000001  [4m2[24m016 -[31m0[39m[31m.[39m[31m836[39m
#> [90m3[39m W92000001  [4m2[24m017  0.330
#> [90m4[39m W92000001  [4m2[24m018  0.487
#> [90m5[39m W92000001  [4m2[24m019  0.576
#> [90m6[39m W92000001  [4m2[24m020  1.51 
#> [90m# … with 8 more rows[39m
```
### Dates and times

> TODO:
>
> Explain [reference.data.gov.uk](https://github.com/epimorphics/IntervalServer/blob/master/interval-uris.md) in a friendly way.
>
> Do we separate out months vs. years vs. quarters?

```ttl
<http://reference.data.gov.uk/id/year/2021>
    a                               interval:Year , interval:CalendarYear , scv:Dimension ;
    rdfs:comment                    "The British calendar year of 2021"@en ;
    rdfs:label                      "British Year:2021"@en ;
    scv:max                         "2021-12-31"^^xsd:date ;
    scv:min                         "2021-01-01"^^xsd:date ;
    time:intervalContains           <http://reference.data.gov.uk/id/month/2021-01>, 
        <http://reference.data.gov.uk/id/month/2021-02>,
        <http://reference.data.gov.uk/id/month/2021-03,
        # ...
    .
```

```ttl
<http://reference.data.gov.uk/id/government-year/2021-2022>
    a                               interval:Year , scv:Dimension , interval:BusinessYear ;
    rdfs:comment                    "The Modern HMG calendar year of 2021-2022"@en ;
    rdfs:label                      "Modern HMG Year:2021-2022"@en ;
    scv:max                         "2022-03-31"^^xsd:date ;
    scv:min                         "2021-04-01"^^xsd:date ;
    time:intervalContains           <http://reference.data.gov.uk/id/month/2021-04>, 
        <http://reference.data.gov.uk/id/month/2021-05>,
        <http://reference.data.gov.uk/id/month/2021-06>,
        # ...
    .
```

The service offers two main sets of calendars:

- [Calendar](https://github.com/epimorphics/IntervalServer/blob/master/interval-uris.md#british-calendar-intervals) intervals, aligning to the 1st January. 
- ["Government" calendar](https://github.com/epimorphics/IntervalServer/blob/master/interval-uris.md#modern-government-business-intervals) intervals, aligning to the 1st April.

Name               | Pattern        | Example
------------------ | -------------- | -------
Calendar year      | `YYYY`         | `2021`
Calendar half      | `YYYY-Hk`      | `2021-Q1`
Calendar quarter   | `YYYY-Qk`      | `2021-Q1`
Calendar week      | `YYYY-Wk`      | `2021-W1`
Calendar day       | `YYYY-MM-DD`   | `2021-01-01`
Government year    | `YYYY-ZZZZ`    | `2021-2022`
Government half    | `YYYY-ZZZZ/Hk` | `2021-2022/H1`
Government quarter | `YYYY-ZZZZ/Qk` | `2021-2022/Q1`
Government week    | `YYYY-ZZZZ/Wk` | `2021-2022/W1`

Calendar weeks and government weeks begin on a Monday, with the first week containing the 4th of January or 4th of April respectively.

> TODO: Other types of year e.g. academic years.

### UK geographies

> TODO: Explain statistics.data.gov.uk in a friendly way.

### Multiple Measures

> TODO: Explain how to pivot a wide, multiple measure dataframe into a long, measure-dimension dataframe.


```r
library(dplyr, warn.conflicts = FALSE)
library(tidyr)

set.seed(1) # Used to control randomness in the examples

df <- expand_grid(
        year = 2020:2021,
        geography = c("W92000001", "E92000001")) %>%
    mutate(
        population = round(1000000 + rnorm(2 * 2) * 10000),
        gdp = round(1000000 + rnorm(2 * 2) * 10000))

df
#> [90m# A tibble: 4 × 4[39m
#>    [1myear[22m [1mgeography[22m [1mpopulation[22m     [1mgdp[22m
#>   [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m          [3m[90m<dbl>[39m[23m   [3m[90m<dbl>[39m[23m
#> [90m1[39m  [4m2[24m020 W92000001     [4m9[24m[4m9[24m[4m3[24m735 1[4m0[24m[4m0[24m[4m3[24m295
#> [90m2[39m  [4m2[24m020 E92000001    1[4m0[24m[4m0[24m[4m1[24m836  [4m9[24m[4m9[24m[4m1[24m795
#> [90m3[39m  [4m2[24m021 W92000001     [4m9[24m[4m9[24m[4m1[24m644 1[4m0[24m[4m0[24m[4m4[24m874
#> [90m4[39m  [4m2[24m021 E92000001    1[4m0[24m[4m1[24m[4m5[24m953 1[4m0[24m[4m0[24m[4m7[24m383
```



```r
df %>% pivot_longer(
    cols = c("population", "gdp"),
    names_to = "measure_type"
)
#> [90m# A tibble: 8 × 4[39m
#>    [1myear[22m [1mgeography[22m [1mmeasure_type[22m   [1mvalue[22m
#>   [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m     [3m[90m<chr>[39m[23m          [3m[90m<dbl>[39m[23m
#> [90m1[39m  [4m2[24m020 W92000001 population    [4m9[24m[4m9[24m[4m3[24m735
#> [90m2[39m  [4m2[24m020 W92000001 gdp          1[4m0[24m[4m0[24m[4m3[24m295
#> [90m3[39m  [4m2[24m020 E92000001 population   1[4m0[24m[4m0[24m[4m1[24m836
#> [90m4[39m  [4m2[24m020 E92000001 gdp           [4m9[24m[4m9[24m[4m1[24m795
#> [90m5[39m  [4m2[24m021 W92000001 population    [4m9[24m[4m9[24m[4m1[24m644
#> [90m6[39m  [4m2[24m021 W92000001 gdp          1[4m0[24m[4m0[24m[4m4[24m874
#> [90m# … with 2 more rows[39m
```

### Hierarchies

> TODO: What do you do when you have a parent -> child relationship in the dataset. We need to make explicit that columns should be orthogonal from one another.


```r
library(dplyr, warn.conflicts = FALSE)
library(tidyr)
library(stringr)

set.seed(1) # Used to control randomness in the examples

df1 <- expand_grid(
        year = 2020:2021,
        local_authority = c(
            "W06000015", # Cardiff
            "W06000011"  # Swansea
    )) %>%
    mutate(country = "W92000001", .before = local_authority) %>%
    mutate(value = rnorm(2 * 2))

df2 <- expand_grid(
        year = 2020:2021,
        country = "W92000001",
        local_authority = NA
    ) %>%
    mutate(value = rnorm(2 * 1))

df <- bind_rows(df1, df2)

df
#> [90m# A tibble: 6 × 4[39m
#>    [1myear[22m [1mcountry[22m   [1mlocal_authority[22m  [1mvalue[22m
#>   [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m     [3m[90m<chr>[39m[23m            [3m[90m<dbl>[39m[23m
#> [90m1[39m  [4m2[24m020 W92000001 W06000015       -[31m0[39m[31m.[39m[31m626[39m
#> [90m2[39m  [4m2[24m020 W92000001 W06000011        0.184
#> [90m3[39m  [4m2[24m021 W92000001 W06000015       -[31m0[39m[31m.[39m[31m836[39m
#> [90m4[39m  [4m2[24m021 W92000001 W06000011        1.60 
#> [90m5[39m  [4m2[24m020 W92000001 [31mNA[39m               0.330
#> [90m6[39m  [4m2[24m021 W92000001 [31mNA[39m              -[31m0[39m[31m.[39m[31m820[39m
```


```r
df %>%
    mutate(
        geography = coalesce(local_authority, country), 
        .after = local_authority
    ) %>%
    select(-local_authority, -country)
#> [90m# A tibble: 6 × 3[39m
#>    [1myear[22m [1mgeography[22m  [1mvalue[22m
#>   [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m      [3m[90m<dbl>[39m[23m
#> [90m1[39m  [4m2[24m020 W06000015 -[31m0[39m[31m.[39m[31m626[39m
#> [90m2[39m  [4m2[24m020 W06000011  0.184
#> [90m3[39m  [4m2[24m021 W06000015 -[31m0[39m[31m.[39m[31m836[39m
#> [90m4[39m  [4m2[24m021 W06000011  1.60 
#> [90m5[39m  [4m2[24m020 W92000001  0.330
#> [90m6[39m  [4m2[24m021 W92000001 -[31m0[39m[31m.[39m[31m820[39m
```


```r
# TODO: Turn this into a proper function.
hierarchy <- df %>%
    select(parent_notation = country, notation = local_authority)

notations <- unique(c(hierarchy$notation, hierarchy$parent_notation))
notations <- notations[!is.na(notations)]

codelist <- tibble(notation = notations) %>%
    left_join(hierarchy, by = "notation")

codelist
#> [90m# A tibble: 5 × 2[39m
#>   [1mnotation[22m  [1mparent_notation[22m
#>   [3m[90m<chr>[39m[23m     [3m[90m<chr>[39m[23m          
#> [90m1[39m W06000015 W92000001      
#> [90m2[39m W06000015 W92000001      
#> [90m3[39m W06000011 W92000001      
#> [90m4[39m W06000011 W92000001      
#> [90m5[39m W92000001 [31mNA[39m
```

### Statistical markers

> TODO: How to deal with missing values, or marks which indicate non-disclosure etc.

The UK Government Statistical Service provides advice on [using symbols and shorthand in statistical tables](https://gss.civilservice.gov.uk/policy-store/symbols-in-tables-definitions-and-help/). Previously, this involved using symbols such as `:`, `*` or `†` to describe things like an observation being suppressed due to non disclosure or statistical significance. New [draft guidance](https://github.com/best-practice-and-impact/using-symbols-in-tables-draft-update/blob/main/draft-one.md) no longer recommends the use of these specific symbols, but instead recommends using letters such a `[c]` or `[x]`. We refer to these as **markers**.


```r
library(dplyr, warn.conflicts = FALSE)
library(tidyr)

set.seed(1) # Used to control randomness in the examples

df <- expand_grid(year = 2020:2021,
                  geography = c("W92000001", "E92000001")) %>%
    mutate(value = rnorm(2 * 2)) %>%
    rowwise() %>%
    mutate(value = sample(c(value, "[c]"), size = 1)) %>%
    ungroup()

df
#> [90m# A tibble: 4 × 3[39m
#>    [1myear[22m [1mgeography[22m [1mvalue[22m             
#>   [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m     [3m[90m<chr>[39m[23m             
#> [90m1[39m  [4m2[24m020 W92000001 [c]               
#> [90m2[39m  [4m2[24m020 E92000001 [c]               
#> [90m3[39m  [4m2[24m021 W92000001 -0.835628612410047
#> [90m4[39m  [4m2[24m021 E92000001 1.59528080213779
```

We notice R has interpreted the `value` column as containing characters rather than numbers due to the introduction of the `[c]` symbol. This causes some unideal behaviour when trying to use the data to compute further statistics.


```r
mean(df$value)
#> Warning in mean.default(df$value): argument is not numeric or logical: returning
#> NA
#> [1] NA
```

We require that the data be separated into a `value` column and a `marker` column, with the `marker` column including these sorts of symbols. We also require that the `marker` column be limited to containing _one_ marker only. If there is a need to mark observations with multiple markers, we advice creating multiple columns, one for each marker.


```r
# TODO: Turn this into a proper function.
extract_markers <- function(x) {
  x[!suppressWarnings(is.na(as.numeric(x)))] <- NA
  return(x)
}

df %>%
    mutate(
        marker = extract_markers(value),
        value = suppressWarnings(as.numeric(value))
    )
#> [90m# A tibble: 4 × 4[39m
#>    [1myear[22m [1mgeography[22m  [1mvalue[22m [1mmarker[22m
#>   [3m[90m<int>[39m[23m [3m[90m<chr>[39m[23m      [3m[90m<dbl>[39m[23m [3m[90m<chr>[39m[23m 
#> [90m1[39m  [4m2[24m020 W92000001 [31mNA[39m     [c]   
#> [90m2[39m  [4m2[24m020 E92000001 [31mNA[39m     [c]   
#> [90m3[39m  [4m2[24m021 W92000001 -[31m0[39m[31m.[39m[31m836[39m [31mNA[39m    
#> [90m4[39m  [4m2[24m021 E92000001  1.60  [31mNA[39m
```

## Representing as linked data

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

### CSV on the Web (CSVW)

> TODO: Explain the CSV on the Web (CSVW) format.

## Examples

### Quarterly Stamp Duty Land Tax (SDLT) statistics

We take an extract of `Table_2a` of [Quarterly Stamp Duty Land Tax (SDLT) statistics](https://www.gov.uk/government/statistics/quarterly-stamp-duty-land-tax-sdlt-statistics).


```r
# https://www.gov.uk/government/statistics/quarterly-stamp-duty-land-tax-sdlt-statistics

df <- tibble::tibble(
  `Financial Year`                                  = c("2019-20", "2020-21"),
  `All liable transactions under £250K`             = c(290200,    157100),
  `HRAD transactions under £250K`                   = c(135400,    117600),
  `All liable transactions between £250K and £500K` = c(279600,    98500),
  `HRAD transactions between £250K and £500K`       = c(56100,     52800)
)

knitr::kable(df)
```



|Financial Year | All liable transactions under £250K| HRAD transactions under £250K| All liable transactions between £250K and £500K| HRAD transactions between £250K and £500K|
|:--------------|-----------------------------------:|-----------------------------:|-----------------------------------------------:|-----------------------------------------:|
|2019-20        |                              290200|                        135400|                                          279600|                                     56100|
|2020-21        |                              157100|                        117600|                                           98500|                                     52800|


We can see this looks like a cross tabulation of year and transaction details. To make it tidy, the transaction details belong in their own column.

This example is interesting because under closer inspection we can see the transaction details contain two pieces of information, the type of transaction (e.g. `All liable transactions` and `HRAD transactions`), and the price band of those transactions (`under £250k`, `between £250k and £500k`).

Additionally, the sources' footnotes mention data from 2020-21 are provisional.

Our approach is:

- Pivot the dataframe into a longer format.
- Split out the column headers into two pieces of information, the transaction type and the transaction price band.
- Explicitly mark provisional data in the data.


```r
library(dplyr, warn.conflicts = FALSE)
library(tidyr)
library(stringr)

tidy_df <- df %>%
  pivot_longer(cols = !`Financial Year`,
               values_to = "transactions") %>%
  # https://www.statworx.com/de/blog/strsplit-but-keeping-the-delimiter/
  separate(
    name,
    into = c("transaction_type", "transaction_price_band"),
    sep = "(?=under |between )"
  ) %>%
  rename(financial_year = `Financial Year`) %>%
  mutate(
    transaction_type = str_trim(transaction_type),
    transaction_price_band = str_to_sentence(transaction_price_band)
  ) %>%
  mutate(marker = case_when(financial_year == "2020-21" ~ "[p]"))

tidy_df
#> [90m# A tibble: 8 × 5[39m
#>   [1mfinancial_year[22m [1mtransaction_type[22m      [1mtransaction_price_ba…[22m [1mtransactions[22m [1mmarker[22m
#>   [3m[90m<chr>[39m[23m          [3m[90m<chr>[39m[23m                 [3m[90m<chr>[39m[23m                        [3m[90m<dbl>[39m[23m [3m[90m<chr>[39m[23m 
#> [90m1[39m 2019-20        All liable transacti… Under £250k                 [4m2[24m[4m9[24m[4m0[24m200 [31mNA[39m    
#> [90m2[39m 2019-20        HRAD transactions     Under £250k                 [4m1[24m[4m3[24m[4m5[24m400 [31mNA[39m    
#> [90m3[39m 2019-20        All liable transacti… Between £250k and £5…       [4m2[24m[4m7[24m[4m9[24m600 [31mNA[39m    
#> [90m4[39m 2019-20        HRAD transactions     Between £250k and £5…        [4m5[24m[4m6[24m100 [31mNA[39m    
#> [90m5[39m 2020-21        All liable transacti… Under £250k                 [4m1[24m[4m5[24m[4m7[24m100 [p]   
#> [90m6[39m 2020-21        HRAD transactions     Under £250k                 [4m1[24m[4m1[24m[4m7[24m600 [p]   
#> [90m# … with 2 more rows[39m
```
