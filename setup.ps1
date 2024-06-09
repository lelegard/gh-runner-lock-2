function Display-Duration($start)
{
    $d = (Get-Date) - $start
    Write-Output "Duration: $($d.ToString())"
}

Write-Output ""
Write-Output "==== Search all Visual Studio"
Write-Output ""

$start = Get-Date

Get-ChildItem -Recurse -Depth 1 -Directory "C:\Program Files\Microsoft Visual Studio" |
    ForEach-Object {$_.FullName}

Display-Duration $start

Write-Output ""
Write-Output "==== Find MSBuild, fast method"
Write-Output ""

$start = Get-Date

Get-ChildItem "C:\Program Files\Microsoft Visual Studio\*\*\MSBuild\Current\Bin\MSBuild.exe" |
    ForEach-Object { Write-Output $_.FullName }

Display-Duration $start

Write-Output ""
Write-Output "==== Find MSBuild, full search"
Write-Output ""

$start = Get-Date

$MSRoots = @("C:\Program Files*\MSBuild", "C:\Program Files*\Microsoft Visual Studio")
Get-ChildItem -Recurse -Path $MSRoots -Include MSBuild.exe -ErrorAction Ignore |
    ForEach-Object { (Get-Command $_).FileVersionInfo } |
    Sort-Object -Property FileVersion |
    ForEach-Object { Write-Output "$($_.FileName) => $($_.FileVersion)" }

Display-Duration $start

Write-Output ""
Write-Output "==== Search MSVC redistributable installer"
Write-Output ""

$start = Get-Date

Get-ChildItem -Recurse -Path "C:\Program Files*\Microsoft Visual Studio" -Include "vc*redist*x64.exe" -ErrorAction Ignore |
    ForEach-Object { (Get-Command $_).FileVersionInfo } |
    Sort-Object -Property FileVersion  |
    ForEach-Object { Write-Output "$($_.FileName) => $($_.FileVersion)" }

Display-Duration $start
