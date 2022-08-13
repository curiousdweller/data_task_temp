select
  date_part('year', block_time) as year,
  date_part('month', block_time) as month,
  SUM(usd_amount) as vol
from
  dex.trades
where
  block_time >= '2021-01-01'
  AND tx_to IN (
    '\x11111112542d85b3ef69ae05771c2dccff4faa26',
    '\xDef1C0ded9bec7F1a1670819833240f027b25EfF',
    '\x1111111254fb6c44bAC0beD2854e76F90643097d',
    '\x111111125434b319222cdbf8c261674adb56f3ae',
    '\x1bD435F3C054b6e901B7b108a0ab7617C808677b',
    '\x881D40237659C251811CEC9c364ef91dC08D300C',
    '\x9008D19f58AAbD9eD0D60971565AA8510560ab41',
    '\x03f34be1bf910116595db1b11e9d1b2ca5d59659'
  )
  AND project = 'Sushiswap'
  AND usd_amount is NOT NULL
GROUP BY
  year,
  month
ORDER BY
  year,
  month 
  
  -- \x11111112542d85b3ef69ae05771c2dccff4faa26 --> 1inch
  -- \xDef1C0ded9bec7F1a1670819833240f027b25EfF --> 0x
  -- \x1111111254fb6c44bAC0beD2854e76F90643097d --> 1icnh
  -- \x111111125434b319222cdbf8c261674adb56f3ae --> 1inch
  -- \x1bD435F3C054b6e901B7b108a0ab7617C808677b --> paraswap
  -- \x881D40237659C251811CEC9c364ef91dC08D300C --> MM agg
  -- \x9008D19f58AAbD9eD0D60971565AA8510560ab41 --> Cow
  -- \x03f34be1bf910116595db1b11e9d1b2ca5d59659 --> tokenlon
  
  
  
  
/* Helper query to find the top 8 aggregators by volume*/
select
  SUM(usd_amount) as vol,
  tx_to as to
from
  dex.trades
where
  tx_to != '\xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F'
    AND project = 'Sushiswap'
    AND usd_amount is NOT NULL
    GROUP BY
      tx_to
    ORDER BY
      vol desc
