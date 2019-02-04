# sExchangeR.ps1
# [ sɛks ˈʧeɪnʤ ]
# 
# Simple Exchange Reporting 
# (and monitoring)
#


# data source
#$ids="email@ddress.com"
$ids=@(get-content ".\listofaddresses.txt")

# tally vars
$dataTotalSum = 0;
$dataProgressSum = 0;

# report array
$rep=@()

# do the thing
$ids |% {

    # fields to display, start large, cull, less > more
    $rep +=	(Get-MigrationUser -identity $_ |` 
		     Get-MigrationUserStatistics |`
 		     select Identity,TotalQueuedDuration,TotalInProgressDuration,SyncedItemCount,`

             # @{Name="GB"; Expression={[math]::round($_.size/1GB, 2)}}

		     EstimatedTotalTransferSize,BytesTransferred)
 
    # parse byte counts
    $dataTotal = (($rep[-1].EstimatedTotalTransferSize `
                 -split("\(") -split("\)"))[1] `
                 -split(" "))[0] -replace(",","")

    $dataProgress = (($rep[-1].BytesTransferred `
                 -split("\(") -split("\)"))[1] `
                 -split(" "))[0] -replace(",","") 

    # sum them
    $dataTotalSum += $dataTotal
    $dataProgressSum += $dataProgress

}

# table or whatver
$rep | ft -autosize

# summary
write-host (-join "Progess: ", [math]::round($dataProgressSum / 1GB), " GB")
write-host (-join "Total: ", [math]::round($dataTotalSum / 1GB) ," GB")

"Percent Complete: " + [math]::round($dataProgressSum / $dataTotalSum * 100, 2) +"%"


