$featureBranchFormat = "feature/{0}"
$releaseBranchFormat = "release-{0}"

$versionFilepath = "VERSION"

<#
    .Synopsis
    Initialize a git-flow controlled repository.
    
    .Description
    The central repository holds two main branches with an infinite lifetime: 'master' and 'develop'. The HEAD of 
    'origin/master' is considered to be production ready code. The HEAD of 'origin/develop' is the features for the 
    next release. This is where automatic nightly builds would build from.
        
    .Notes
    You'll have to initialize the git repository manually.
    
    C:\PS> git init .
    C:\PS [master]> Set-Content "readme.txt" "my hot new project"
    C:\PS [master +1 ~0 -0 !]> git add .
    C:\PS [master +1 ~0 -0]> git commit -am "initialized repository"
#>
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

<#
    .Synopsis
    Start a new feature branch from the 'develop' branch.
    
    .Description
    Feature branches are used to devleop new features for upcoming releases. The feature branch exists as long as the 
    feature is in development. It will eventually be merged back to the 'develop' branch (or discarded) and the feature
    branch will be deleted.
    
    .Notes
    Feature branches typically exist only in developer repositories and not in the 'origin'.
#>
function Start-Feature {
    param(
        [parameter(Mandatory = $true)]
        [string] $name
    )
    
    $featureBranch = (Format-FeatureBranch $name)
    git checkout -b $featureBranch develop
}

<#
    .Synopsis
    Merge a feature branch with 'develop' and delete the feature branch.
    
    .Description
    Finished features will be merged back into the 'develop' branch and pushed to the 'origin/develop'. The feature
    branch will then be deleted. This function uses '--no-ff' by default (look it up!).
    
    .Notes
    I'd like to make $name optional. If you are currently in a feature branch, this function could simply finish that
    feature.
#>
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

<#
    .Synopsis
    Start a new release branch from the 'develop' branch.
    
    .Description
    Release branches support preparation of a new production release (minor bug fixes, preparing metadata, etc). By 
    doing all of this in a release branch, the 'develop' branch is clear to receive features for the next release. At 
    exactly the start of the release branch, the release will be assigned a version number (in the 'VERSION' file).
    
    .Notes
    I'd like to accept user-customizable versioning schemes (numbering and file name/location).
#>
function Start-Release { 
    param(
        [parameter(Mandatory = $true)]
        [string] $version
    )
    
    $releaseBranch = (Format-ReleaseBranch $version)
    
    git checkout -b $releaseBranch
    
    Set-Content $versionFilepath $version
    git add $versionFilepath
    git commit -a -m "set version to $version"
}

<#
    .Synopsis
    Merge a release branch with 'develop' and 'master' and delete the release branch.
    
    .Description
    When the release branch is ready to become a real release, it is merged with 'master' and 'master' is tagged with 
    the version number. The branch is also merged with 'develop'. The release is done, so the branch is deleted.
    
    .Notes
    I'd like to make $version optional. If you are currently in a release branch, this function could simply finish 
    that release.
#>
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