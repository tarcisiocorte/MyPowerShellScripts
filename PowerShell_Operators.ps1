## WORKING WITH POWERSHELL OPERATORS

$testString = ""

if (![string]::IsNullOrEmpty($testString))
{
    Write-Host "Is not empty or Null"
}
else
{
    Write-Host "Is Empty or Null"
}
