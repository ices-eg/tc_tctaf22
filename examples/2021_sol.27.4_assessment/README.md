# 2021_sol.27.4_assessment

- 2021 - Sole (Solea solea) in Subarea 4 (North Sea) - WGNSSK
- Assessment model: FLa4a

## data

- INPUT
  - `bootstrap/data/data.Rdata`
    - stock, FLStock 1957-2020.
    - refpts, ICES benchmark reference points.
  - `bootstrap/data/discards-landings-stock`
    - canum.txt, catch-at-age in numbers in 2021 from Intercatch.
    - caton.txt, total catch in 2021 from Intercatch.
    - weca.txt, weight-at-age in catch in 2021 from Intercatch.
  - `bootstrap/data/data.Rdata`
    - indices, FLIndices (BTS 1985-2021, SNS 1970-2021).
    - retroindices, FLIndices for retrospective (5 years w/ BTS, SNS).
    - isis, classic ISIS index 1985-2021.

  - `bootstrap/data/catch/StockOverview.txt`
    - Intercatch stock overview file.
  - `bootstrap/data/catch/catches.dat`
    - Table of catches per country, official, bms, ices and tac, 1982-2020.
  - `bootstrap/data/catch/preliminary.dat`
    - Preliminary catches by area, country from ices.dk.

- OUTPUT:
  - `data/data.Rdata`
    - stock, FLStock 1957-2021.
    - indices
    - retroindices
    - refpts
  - `data/catch.Rdata`
    - stats, catch by country and category table, 1985-2021.
    - stov, stock overview table.
  - `data/*.csv`
    - CSV TAF tables stock and indices.

## model

## output

## report



### bootstrap/initial/data

- catch/
  - catches.dat: table of catches by country, 1982-2020.
  - preliminary.dat: preliminary catches by country 2021.
  - StockOverview.txt: Intercatch stock overview file 2022.
- discards: Intercatch VPA files 2021 for discards.
- landings: Intercatch VPA files 2021 for landings.
- stock: Intercatch VPA files 2021 for catch weight-at-age, Q2.
- data.RData: 2020 FLStock, refpts & FLIndices.
- indices.RData: 2021 FLIndices (BTS, SNS) from ices-taf/2021_sol_27.4_survey

### bootstrap/initial/report

- datras: DATRAS plots
- forecast: forecast plots.
- gam: BTS survey GAM plots from ices-taf/2021_sol_27.4_survey.
- intercatch: Intercatch plots.
- reportTemplate.docx: Word template for ICES WG report section.


