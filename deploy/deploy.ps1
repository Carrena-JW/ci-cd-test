# IIS 웹사이트 중지
Import-Module WebAdministration
Stop-WebAppPool -Name "TestSite"
Stop-Website -Name "TestSite"

# 배포 작업 (예: 파일 복사)
Copy-Item -Path "D:\98.publish\TestSite\*" -Destination "D:\99.workspace\TestSite" -Recurse -Force

# IIS 웹사이트 시작
Start-WebAppPool -Name "TestSite"
Start-Website -Name "TestSite"
