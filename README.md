## Workflow 조건처리
```yml
name: Conditional Deployment 🚀

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: self-hosted

    steps:
    - name: Check out repository
      uses: actions/checkout@v2

    - name: Call external API
      id: call-api
      run: |
        response=$(curl -s -X GET "https://api.example.com/check" -H "Authorization: Bearer YOUR_TOKEN")
        echo "API_RESPONSE=$response" >> $GITHUB_ENV

    - name: Check API response
      id: check-response
      run: |
        if [ "$API_RESPONSE" == "A" ]; then
          echo "Response is A, proceeding with deployment."
        elif [ "$API_RESPONSE" == "B" ]; then
          echo "Response is B, failing the job."
          exit 1
        else
          echo "Unexpected response: $API_RESPONSE"
          exit 1
        fi

    - name: Set up .NET
      if: ${{ env.API_RESPONSE == 'A' }}
      uses: actions/setup-dotnet@v2
      with:
        dotnet-version: '8.0.x'

    - name: Install IIS
      if: ${{ env.API_RESPONSE == 'A' }}
      run: |
        Install-WindowsFeature -name Web-Server -IncludeManagementTools
        Install-WindowsFeature -name Web-Asp-Net45

    - name: Install .NET 8 Hosting Bundle
      if: ${{ env.API_RESPONSE == 'A' }}
      run: |
        Invoke-WebRequest -Uri https://dotnet.microsoft.com/download/dotnet/thank-you/runtime-aspnetcore-8.0.0-windows-hosting-bundle-installer -OutFile dotnet-hosting-bundle.exe
        Start-Process -FilePath .\dotnet-hosting-bundle.exe -ArgumentList '/quiet' -Wait

    - name: Restore dependencies
      if: ${{ env.API_RESPONSE == 'A' }}
      run: dotnet restore
      working-directory: ./YourProjectDirectory

    - name: Publish the project
      if: ${{ env.API_RESPONSE == 'A' }}
      run: dotnet publish --configuration Release --output ./YourPublishDirectory
      working-directory: ./YourProjectDirectory

    - name: Run deployment script with elevated privileges
      if: ${{ env.API_RESPONSE == 'A' }}
      run: Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File .\deploy\deploy.ps1" -Verb RunAs
      working-directory: ./YourPublishDirectory

```

## Workflow rollback 
```yaml
name: Publish 🚀

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: self-hosted
    steps:
    - name: Check out repository
      uses: actions/checkout@v2

    - name: Set up .NET
      uses: actions/setup-dotnet@v2
      with:
        dotnet-version: '8.0.x' # .NET 8 버전 설정

    - name: Install IIS
      run: |
        Install-WindowsFeature -name Web-Server -IncludeManagementTools
        Install-WindowsFeature -name Web-Asp-Net45

    - name: Install .NET 8 Hosting Bundle
      run: |
        Invoke-WebRequest -Uri https://dotnet.microsoft.com/download/dotnet/thank-you/runtime-aspnetcore-8.0.0-windows-hosting-bundle-installer -OutFile dotnet-hosting-bundle.exe
        Start-Process -FilePath .\dotnet-hosting-bundle.exe -ArgumentList '/quiet' -Wait

    - name: Restore dependencies
      run: dotnet restore
      working-directory: ./YourProjectDirectory

    - name: Publish the project
      run: dotnet publish --configuration Release --output ./YourPublishDirectory
      working-directory: ./YourProjectDirectory

    - name: Run deployment script with elevated privileges
      run: Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File .\deploy\deploy.ps1" -Verb RunAs
      working-directory: ./YourPublishDirectory

  rollback:
    runs-on: self-hosted
    if: failure()

    steps:
    - name: Check out repository
      uses: actions/checkout@v2

    - name: Run rollback script with elevated privileges
      run: Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File .\rollback\rollback.ps1" -Verb RunAs

```
