require "google/cloud/bigquery"

bigquery = Google::Cloud::Bigquery.new

sql2 = <<-QUERY
SELECT stn, country, state, lat, lon, count(*) as count
FROM `bigquery-public-data.noaa_gsod.gsod2019` D
JOIN (select usaf, country, state, lat, lon from `bigquery-public-data.noaa_gsod.stations` group by 1,2,3,4,5) S on
  D.stn = S.usaf
  AND S.country = 'US'
WHERE temp > 20.5556
      and temp < 32.2222
      and stn != '999999'
group by 1, 2, 3, 4, 5
order by 6 DESC
LIMIT 100
QUERY

# Location must match that of the dataset(s) referenced in the query.
results = bigquery.query(sql2) #do |config|
# 	config.location = "US"
# end

results.each do |row|
	puts row.inspect
end
