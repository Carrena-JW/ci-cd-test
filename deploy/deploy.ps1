$logFilePath = "..\..\..\logs\action.log"
 
Start-Transcript -Path $logFilePath
 
try {
    Import-Module WebAdministration
    Stop-WebAppPool -Name "TestSite"
    Stop-Website -Name "TestSite"


    Copy-Item -Path "..\..\..\publish\*" -Destination "D:\99.workspace\TestSite" -Recurse -Force


    Start-WebAppPool -Name "TestSite"
    Start-Website -Name "TestSite"

}
catch {
    Write-Error "An error occurred: $_"
}
 
Stop-Transcript