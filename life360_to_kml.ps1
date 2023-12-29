$date_regex = '\d{4}-\d{2}-\d{2}'
$time_regex = '\d{2}:\d{2}:\d{2}'
$coord_regex = '\d{2}\.\d{4,6}, -\d{2}\.\d{4,6}'
$files = Get-ChildItem -Filter *.log | % {$_.FullName}

foreach ($file in $files) {
	$current = get-content $file
	$output = "$file.kml"
	
	'<?xml version="1.0" encoding="utf-8"?>' | out-file -FilePath $output -Append
	'<kml xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns="http://www.opengis.net/kml/2.2">' | out-file -FilePath $output -Append
	'  <Document>' | out-file -FilePath $output -Append

	foreach ($line in $current) { 
		if (($line -like '*| NGL |           *') -AND ($line -match '\d{2}\.\d{4,6}, -\d{2}\.\d{4,6}$')) {
			$date = $line | Select-String -Pattern $date_regex | ForEach-Object { $_.Matches.Value }
			$y,$m,$d = $date -split '-', 3
			$dateMDY = "$m/$d/$y"
			
			$time = $line | Select-String -Pattern $time_regex | ForEach-Object { $_.Matches.Value }
			
			$coord = $line | Select-String -Pattern $coord_regex | ForEach-Object { $_.Matches.Value }
			$lat, $lon = $coord -split ', ', 2

			'    <Placemark>' | out-file -FilePath $output -Append
			"      <name>$time $dateMDY</name>" | out-file -FilePath $output -Append
			'      <description>Life360 log entry</description>' | out-file -FilePath $output -Append
			'      <Point>' | out-file -FilePath $output -Append
			"        <coordinates>$lon, $lat, 0</coordinates>" | out-file -FilePath $output -Append
			'      </Point>' | out-file -FilePath $output -Append
			'    </Placemark>' | out-file -FilePath $output -Append
		}
	}
	'  </Document>' | out-file -FilePath $output -Append
	'</kml>' | out-file -FilePath $output -Append
}
