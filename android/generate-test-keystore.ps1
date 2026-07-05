# Creates upload-keystore.jks with the same dummy credentials as key.properties.
# Requires Java (keytool). Install Android Studio or JDK if keytool is not found.

$keystorePath = Join-Path $PSScriptRoot "upload-keystore.jks"

if (Test-Path $keystorePath) {
    Write-Host "Keystore already exists: $keystorePath"
    exit 0
}

$keytool = Get-Command keytool -ErrorAction SilentlyContinue
if (-not $keytool) {
    Write-Error "keytool not found. Install JDK or Android Studio, then run this script again."
    exit 1
}

& keytool -genkey -v `
    -keystore $keystorePath `
    -keyalg RSA `
    -keysize 2048 `
    -validity 10000 `
    -alias upload `
    -storepass salon123456 `
    -keypass salon123456 `
    -dname "CN=Salon Test, OU=Dev, O=SalonBooking, L=Riyadh, ST=Riyadh, C=SA"

Write-Host "Created test keystore: $keystorePath"
