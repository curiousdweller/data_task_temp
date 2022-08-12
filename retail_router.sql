select
  date_part('year', block_time) as year,
  date_part('month', block_time) as month,
  SUM(usd_amount) as monthly_volume_usd
from
  dex.trades
where
  project = 'Sushiswap'
  AND block_time >= '2021-01-01'
  AND tx_to = '\xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F'
Group BY
  year,
  month
ORDER BY
  year,
  month
  ;
