$local = Split-Path -Parent $MyInvocation.MyCommand.Path

######################################################################
# Import Pester
######################################################################
. "$local\..\Pester\Pester.ps1"
. "$local\..\Pester\ObjectAdaptations\PesterFailure.ps1"
. "$local\..\Pester\Functions\TestResults.ps1"

Update-TypeData -PrependPath "$local\..\Pester\ObjectAdaptations\types.ps1xml" `
                -ErrorAction SilentlyContinue
######################################################################

Import-Module posh-git

Get-ChildItem "$local\specs\*.specs.ps1" `
    | %{ & $_.PSPath }