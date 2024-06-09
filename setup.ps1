Write-Output ""
Write-Output "==== Find MSBuild, fast method"
Write-Output ""

Get-ChildItem "C:\Program Files\Microsoft Visual Studio\*\*\MSBuild\Current\Bin\MSBuild.exe" |
    ForEach-Object { Write-Output $_.FullName }

Write-Output ""
Write-Output "==== Find MSBuild, full search"
Write-Output ""

$MSRoots = @("C:\Program Files*\MSBuild", "C:\Program Files*\Microsoft Visual Studio")
Get-ChildItem -Recurse -Path $MSRoots -Include MSBuild.exe -ErrorAction Ignore |
    ForEach-Object { (Get-Command $_).FileVersionInfo } |
    Sort-Object -Property FileVersion |
    ForEach-Object { Write-Output "$($_.FileName) => $($_.FileVersion)" }

Write-Output ""
Write-Output "==== Search MSVC redistributable installer"
Write-Output ""

Get-ChildItem -Recurse -Path "C:\Program Files*\Microsoft Visual Studio" -Include "vc*redist*x64.exe" -ErrorAction Ignore |
    ForEach-Object { (Get-Command $_).FileVersionInfo } |
    Sort-Object -Property FileVersion  |
    ForEach-Object { Write-Output "$($_.FileName) => $($_.FileVersion)" }
