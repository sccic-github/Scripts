# Purpose:
#    - Grab the EVTX logs from a live Windows System and save them in a ZIP file
#    - Useful for when you need to grab EVTX logs from a system to send to SC CIC for review

# Requirements:
#    - Need Administrator Privileges to run this script

# Set paths
$evtxSourcePath = "C:\Windows\System32\winevt\Logs"
$tempCopyPath = "C:\Windows\Temp\Logs"
$zipDestination = "C:\Windows\Temp\evtx_logs.zip"

# Create temp directory
New-Item -ItemType Directory -Path $tempCopyPath -Force | Out-Null

# Copy .evtx files
Get-ChildItem -Path $evtxSourcePath -Filter "*.evtx" -Recurse | ForEach-Object {
    Copy-Item $_.FullName -Destination $tempCopyPath -Force
}

# Create ZIP (requires PowerShell 5.0+)
Compress-Archive -Path "$tempCopyPath\*" -DestinationPath $zipDestination -Force

# Delete the Unzipped Logs
Remove-Item -Path $tempCopyPath -Recurse -Force

# Output result
Write-Host "EVTX files zipped to: $zipDestination"
