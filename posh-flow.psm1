$featureBranchFormat = "feature/{0}"
$releaseBranchFormat = "release-{0}"

$versionFilepath = "VERSION"

function Format-FeatureBranch 
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $name
    )
    
    $featureBranchFormat -f $name
}

# TODO: implement default patch ver increment
# TODO: implement -major, -minor switches
function Format-ReleaseBranch 
{
    param
    (
        [parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string] $version
    )
    
    $releaseBranchFormat -f $version
}

Resolve-Path $PSScriptRoot\*.ps1 `
    | ?{ -not($_.ProviderPath.Contains(".tests.")) } `
    | %{ . $_.ProviderPath }

Export-ModuleMember -Function Init-GitFlow
Export-ModuleMember -Function Start-Feature
Export-ModuleMember -Function Finish-Feature
Export-ModuleMember -Function Start-Release
Export-ModuleMember -Function Finish-Release