param(
    [Parameter(Mandatory=$true)]
    [string]$ExePath,
    [string]$Version = "1.0.0.0",
    [string]$Copyright = "© 2025 MyCompany",
    [string]$Company = "MyCompany",
    [string]$Description = "My Application",
    [string]$ProductName = "MyProduct",
    [string]$CertSubject = "CN=MyCertificate",
    [string]$CertPassword = "CertificatePassword"
)

Write-Host "Creating self-signed certificate..."
$cert = New-SelfSignedCertificate -Type CodeSigningCert -Subject $CertSubject -CertStoreLocation "Cert:\CurrentUser\My"

$pfxPath = "$env:TEMP\mycertificate.pfx"
$securePwd = ConvertTo-SecureString -String $CertPassword -Force -AsPlainText
Export-PfxCertificate -Cert $cert -FilePath $pfxPath -Password $securePwd

# Check if rcedit.exe is present in the same folder as the script
$rcedit = Join-Path $PSScriptRoot "rcedit.exe"
if (-not (Test-Path $rcedit)) {
    Write-Error "rcedit.exe not found in $PSScriptRoot. Download it here: https://github.com/electron/rcedit/releases"
    exit 1
}

Write-Host "Modifying executable metadata..."
& $rcedit $ExePath --set-version-string "FileDescription" "$Description"
& $rcedit $ExePath --set-version-string "ProductName" "$ProductName"
& $rcedit $ExePath --set-version-string "CompanyName" "$Company"
& $rcedit $ExePath --set-version-string "LegalCopyright" "$Copyright"
& $rcedit $ExePath --set-file-version "$Version"
& $rcedit $ExePath --set-product-version "$Version"

# Check if signtool.exe is in the PATH
$signtool = "signtool.exe"
if (-not (Get-Command $signtool -ErrorAction SilentlyContinue)) {
    Write-Error "signtool.exe not found. Please install the Windows SDK and add signtool.exe to your PATH."
    exit 1
}

Write-Host "Signing the executable..."
& $signtool sign /f $pfxPath /p $CertPassword /tr http://timestamp.digicert.com /td sha256 /fd sha256 $ExePath

Write-Host "Done! The executable is signed and updated with the new metadata."
