function Display-Duration($start)
{
    $d = (Get-Date) - $start
    Write-Output "Duration: $($d.ToString())"
}

Write-Output ""
Write-Output "==== Cleanup hostedtoolcache\windows"
Write-Output ""

$start = Get-Date

Get-ChildItem -Path "C:\hostedtoolcache\windows" -File -Include msvcp*.dll,concrt*.dll,vccorlib*.dll,vcruntime*.dll -Recurse |
    Remove-Item -Force -Verbose

Display-Duration $start

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
Write-Output "==== Search MSVC redistributable installer, fast method"
Write-Output ""

$start = Get-Date

Get-ChildItem "C:\Program Files\Microsoft Visual Studio\*\*\VC\Redist\MSVC\*\vc*redist*x64.exe" |
    ForEach-Object { (Get-Command $_).FileVersionInfo } |
    Sort-Object -Property FileVersion  |
    ForEach-Object { Write-Output "$($_.FileName) => $($_.FileVersion)" }

Display-Duration $start

Write-Output ""
Write-Output "==== Search MSVC runtime in Path"
Write-Output ""

$start = Get-Date

foreach ($d in ($env:Path -split ';')) {
    Write-Output "$d"
    if (-not -not $d) {
        if (Test-Path -PathType Container $d) {
            Get-ChildItem "$d\*" -Include @("vcruntime*.dll", "msvc*.dll") |
                ForEach-Object { (Get-Command $_).FileVersionInfo } |
                ForEach-Object { Write-Output "    $($_.FileName) => $($_.FileVersion)" }
        }
        else {
            Write-Output "    ==> non existent"
        }
    }
}

Display-Duration $start
