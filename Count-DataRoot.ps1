[CmdletBinding()]
param (
    [Parameter(mandatory=$false)]
    [char]$InternalDrive = "F",
    [string]$ExternalDriveName = "Data-Backup"
)
$ErrorActionPreference = "Stop"

$n = $InternalDrive
$x = (Get-Volume -FriendlyName $ExternalDriveName).DriveLetter

Write-Warning "This check does NOT detect discrepencies within files!"
$folders = @()

foreach($folder in Get-ChildItem -Path "$($InternalDrive):") {
    Write-Host "Comparing \$folder...`t" -NoNewLine
    
    $nCount = (Get-ChildItem "$($n):\$folder" -File -Recurse -Force | measure).count    # -File to exclude folders; -Recurse to get files in subfolders; -Force to include hidden files (which show in right-click count)
    $xCount = (Get-ChildItem "$($x):\$folder" -File -Recurse -Force | measure).count
    
    if($nCount -eq $xCount) { Write-Host "EQUAL " -f green -NoNewLine }
    else { Write-Host "DIFF " -f red -NoNewLine }
    
    Write-Host "`t$nCount ($n) to $xCount ($x)"
}