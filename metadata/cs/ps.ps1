#!/
Param(
    [ValidateSet("debug", "release")][string]$Configuration="debug",
	[switch]$CleanCache,
    [ValidateSet("NuGet3", "NuGet.PackageManagement", "NuGet.VisualStudioExtension", "pm", "vsix")][string]$FirstRepo = "NuGet3",
    [ValidateRange(0,100)][string]$score=2,
    [string]$course="aa"
)


# New-item -Path ./a.txt -Value $env:COMPUTERNAME -ItemType "file" -Force 
# (gci env:*)| Sort-Object Name | Out-String
# Invoke-Item .\a.txt
# New-Variable -Name Max -Value 256 -Option ReadOnly

#
function Some-None ($score,$course) {
    Write-Host($score + " : " + $course)
}
&Some-None $score $course

# Clear-Host
# pushd  $env:Path
# popd
Write-Host($PWD)

# 转到 path
# Set-Location -Path C:\Windows -PassThru # alias for cd chdir sl
# Get-Process | Where-Object -FilterScript {$_.Responding -eq $false} | Stop-Process
