# IIS ������Ʈ ����
Import-Module WebAdministration
Stop-WebAppPool -Name "TestSite"
Stop-Website -Name "TestSite"

# ���� �۾� (��: ���� ����)
Copy-Item -Path "D:\98.publish\TestSite\*" -Destination "D:\99.workspace\TestSite" -Recurse -Force

# IIS ������Ʈ ����
Start-WebAppPool -Name "TestSite"
Start-Website -Name "TestSite"
