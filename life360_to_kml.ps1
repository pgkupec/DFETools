$date_regex = '\d{4}-\d{2}-\d{2}'
$time_regex = '\d{2}:\d{2}:\d{2}'
$coord_regex = '\d{2}\.\d{4,6}, -\d{2}\.\d{4,6}'
$files = Get-ChildItem -Filter *.log | % {$_.FullName}	# add -Recurse before -Filter to include subdirectories

foreach ($file in $files) {		#loops through each file in directory
	$current = get-content $file
	$output = "$file.kml"
	$linectr = 1
	
	'<?xml version="1.0" encoding="utf-8"?>' | out-file -FilePath $output -Append
	'<kml xmlns:gx="http://www.google.com/kml/ext/2.2" xmlns="http://www.opengis.net/kml/2.2">' | out-file -FilePath $output -Append
	'  <Document>' | out-file -FilePath $output -Append

	foreach ($line in $current) {	#loops through each line in file
		if (($line -like '*| NGL |           *') -AND ($line -match '\d{2}\.\d{4,6}, -\d{2}\.\d{4,6}$')) {
			$date = $line | Select-String -Pattern $date_regex | ForEach-Object { $_.Matches.Value }	#saves date to variable
			$y,$m,$d = $date -split '-', 3	#splits date into separate variables
			
			$time = $line | Select-String -Pattern $time_regex | ForEach-Object { $_.Matches.Value }	#saves time to variable
			
			$coord = $line | Select-String -Pattern $coord_regex | ForEach-Object { $_.Matches.Value }	#saves coordinates to variable
			$lat, $lon = $coord -split ', ', 2	#splits coordinate into separate variables

			'    <Placemark>' | out-file -FilePath $output -Append
			"      <name>$time $m/$d/$y</name>" | out-file -FilePath $output -Append	#reorder date to be more visually pleasing
			"      <description>Life360 log entry, line $linectr</description>" | out-file -FilePath $output -Append	#adds note with line from log file
			'      <Point>' | out-file -FilePath $output -Append
			"        <coordinates>$lon, $lat, 0</coordinates>" | out-file -FilePath $output -Append	#KML requires longitude before latitude
			'      </Point>' | out-file -FilePath $output -Append
			'    </Placemark>' | out-file -FilePath $output -Append
		}
		$linectr++
	}
	'  </Document>' | out-file -FilePath $output -Append
	'</kml>' | out-file -FilePath $output -Append
}
