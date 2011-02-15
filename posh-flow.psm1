$featureBranchFormat = "feature/{0}"
$releaseBranchFormat = "release-{0}"

$versionFilepath = "VERSION"

# account for a non-git repo? you'll have to perform, at least
#     git init .
#     Set-Content readme.txt ""
#     git add .
#     git commit -a -m "initialized repository"
function Init-GitFlow {
    git checkout -b develop master
}

function Format-FeatureBranch {
    param(
        [parameter(Mandatory = $true)]
        [string] $name
    )
    
    $featureBranchFormat -f $name
}

function Format-ReleaseBranch {
    param(
        [parameter(Mandatory = $true)]
        [string] $version
    )
    
    $releaseBranchFormat -f $version
}

# restrict this operation from 'develop'
function Start-Feature {
    param(
        [parameter(Mandatory = $true)]
        [string] $name
    )
    
    $featureBranch = (Format-FeatureBranch $name)
    git checkout -b $featureBranch develop
}

# make $name optional, instead finishing the current feature... would have to inspect the branch name?
function Finish-Feature {
    param(
        [parameter(Mandatory = $true)]
        [string] $name
    )
    
    $featureBranch = (Format-FeatureBranch $name)
    
    git checkout develop
    git merge --no-ff $featureBranch
    git branch -d $featureBranch
}

# restrict this operation from 'develop'
function Start-Release { 
    param(
        [parameter(Mandatory = $true)]
        [string] $version
    )
    
    $featureBranch = (Format-ReleaseBranch $version)
    
    git checkout -b $featureBranch
    
    Set-Content $versionFilepath $version
    git add $versionFilepath
    git commit -a -m "set version to $version"
}

function Finish-Release {
    param(
        [parameter(Mandatory = $true)]
        [string] $version
    )
    
    $releaseBranch = (Format-ReleaseBranch $version)
    
    git checkout master
    git merge --no-ff $releaseBranch
    git tag -a -m "released $version" $version
    
    git checkout develop
    git merge --no-ff $releaseBranch
    
    git branch -d $releaseBranch
}

Export-ModuleMember -Function Init-GitFlow
Export-ModuleMember -Function Start-Feature
Export-ModuleMember -Function Finish-Feature
Export-ModuleMember -Function Start-Release
Export-ModuleMember -Function Finish-Release