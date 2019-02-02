# sexChangeR.ps1 
#
# Simple Exchange Report
#

 
# source mailbox(es)
#$ids="whobe@thismailbox.com"
$ids=@(get-content ".\listofmailboxes.txt")

#  G, M, K Bytes 
$G = [int](1024*1024*1024)
$M = [int](1024*1024)
$K = [int](1024)

# report array
$rep=@()

# do the thing
$ids |% {

# fields to display, start large, cull, less > more
    $rep +=	(Get-MigrationUser -identity $_ |` 
		Get-MigrationUserStatistics |`
 		select Identity,TotalQueuedDuration,TotalInProgressDuration,SyncedItemCount,`
		EstimatedTotalTransferSize,BytesTransferred)
 
# get bytes, apply logic, make functional
    $dataTotal = ($rep[-1].EstimatedTotalTransferSize)
    $dataInProgress = ($rep[-1].BytesTransferred) 

    $dataTotal = [int]($dataTotal -Split(" ")[0])[0].trim()
    $dataInProgress = [int]($dataInProgress.BytesTransferred -Split(" ")[0])[0].trim()

    $dataTotal = $dataTotal.ToString() -split(" ")
    $dataInProgress = $dataInProgress.ToString() -split(" ")

# found no native handling for bandwitdh/units. weird.
# just does G and M for now, K coming soon
    if ($dataTotal[1] -eq "MB" ) { 
        $dataTotal *= $M 
    } elseif ( $dataTotal[1] -eq "GB") { 
            $dataTotal *= $G 
        } else { $dataTotal *= 1 }

    if ( $dataInProgress[1] -eq "MB" ) { 
            $dataInProgress *= $M   
        } elseif ( $dataInProgress[1] -eq "GB") { 
            $dataInProgress *= $G 
        } else { $dataInProgress *= 1 }

    if (($dataInProgress -eq 0) -or ($dataInProgress -eq 0)) {
       #  $nada 
        } else { 
            [int]$dataProgressBytes = ($dataInProgress * $dataInProgress)
        }
    
    if (($esd -eq 0) -or ($dataTotal -eq 0)) { 
       # $nada 
        } else { 
            [int]$dataTotalBytes = ($dataTotal * $dataTotal)
        }  
}

# table or whatver
$rep | ft -autosize

# summary, broken
write-host (-join "Total: ", ($dataTotal/$G,2))," GB")
write-host (-join "Progess: ",($dataInProgress/$G,2))," GB")
