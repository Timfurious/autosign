# autosign PowerShell Script to Sign and Customize Windows Executables

autosign is a PowerShell script that allows you to:

Generate a self-signed code signing certificate

Add or modify executable metadata (version, copyright, description, etc.)

Automatically sign the executable with the generated certificate

Features

Quick creation of a self-signed code signing certificate

Edit version and copyright information of .exe files using rcedit

Digitally sign the executable with signtool

Requirements

PowerShell

rcedit (place in the same folder as the script)

signtool (included with the Windows SDK)

Usage :

.\sign.ps1 -ExePath "path\to\yourapp.exe" -Version "1.0.0.0" -Copyright "© 2025"

Perfect for developers who want to test code signing or quickly customize the properties of their Windows executables.
