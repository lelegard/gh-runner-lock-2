function Display-Duration($start)
{
    $d = (Get-Date) - $start
    Write-Output "Duration: $($d.ToString())"
}

Write-Output ""
Write-Output "==== Search MSVC redistributable installer"
Write-Output ""

$start = Get-Date

$VCRedist64 = Get-ChildItem "C:\Program Files\Microsoft Visual Studio\*\*\VC\Redist\MSVC\*\vc*redist*x64.exe" -ErrorAction Ignore |
              ForEach-Object { (Get-Command $_).FileVersionInfo } |
              Sort-Object -Unique -Property FileVersion  |
              ForEach-Object { $_.FileName} | Select-Object -Last 1

Display-Duration $start

if (-not $VCRedist64) {
    Write-Output "MSVC Redistributable Libraries 64-bit Installer not found"
}
else {
    Write-Output "Installing $VCRedist64"
    $start = Get-Date
    & $VCRedist64 /q /norestart
    Display-Duration $start
}
