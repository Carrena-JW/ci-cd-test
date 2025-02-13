$logFilePath = "..\..\logs\action.log"
 
Start-Transcript -Path $logFilePath
 
try {
    Import-Module WebAdministration

    if((Get-WebAppPoolState "TestSite").Value -ne "Stopped")
    {
        Stop-WebAppPool -Name "TestSite" 
    }
    
    if((Get-WebsiteState "TestSite").Value -ne "Stopped")
    {
        Stop-Website -Name "TestSite" 
    }

    Start-Sleep -Seconds 20

    Copy-Item -Path "..\..\publish\*" -Destination "D:\99.workspace\TestSite" -Recurse -Force

    Start-WebAppPool -Name "TestSite"
    Start-Website -Name "TestSite"

}
catch {
    Write-Error "An error occurred: $_"
}
 
Stop-Transcript
