$featureBranchFormat = "feature/{0}"
$releaseBranchFormat = "release-{0}"

$versionFilepath = "VERSION"

<#
    .SYNOPSIS
    Initialize a git-flow controlled repository.
    
    .DESCRIPTION
    The central repository holds two main branches with an infinite lifetime: 'master' and 'develop'. The HEAD of 
    'origin/master' is considered to be production ready code. The HEAD of 'origin/develop' is the features for the 
    next release. This is where automatic nightly builds would build from.
        
    .NOTES
    This function will initialize a directory as a git repository if necessary. It will create a readme and a 
    gitignore file and commit them to start up the master branch.
#>
function Init-GitFlow {
    if(-not(Test-Path .git)) {
        git init .
        Set-Content readme.txt ""
        Set-Content .gitignore ""
        git add .
        git commit -a -m "initialized repository"
    }

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
    .SYNOPSIS
    Start a new feature branch from the 'develop' branch.
    
    .DESCRIPTION
    Feature branches are used to devleop new features for upcoming releases. The feature branch exists as long as the 
    feature is in development. It will eventually be merged back to the 'develop' branch (or discarded) and the feature
    branch will be deleted.
    
    .PARAMETER name
    The name of the feature to start.
    
    .NOTES
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
    .SYNOPSIS
    Merge a feature branch with 'develop' and delete the feature branch.
    
    .DESCRIPTION
    Finished features will be merged back into the 'develop' branch and pushed to the 'origin/develop'. The feature
    branch will then be deleted. This function uses '--no-ff' by default (look it up!).
    
    .PARAMETER name
    The name of the feature to finish.
    
    .NOTES
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
    
    # TODO: check for remote/develop first
    git push origin develop
}

<#
    .SYNOPSIS
    Start a new release branch from the 'develop' branch.
    
    .DESCRIPTION
    Release branches support preparation of a new production release (minor bug fixes, preparing metadata, etc). By 
    doing all of this in a release branch, the 'develop' branch is clear to receive features for the next release. At 
    exactly the start of the release branch, the release will be assigned a version number (in the 'VERSION' file).
    
    .PARAMETER version
    The version of the release to start.
    
    .NOTES
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
    .SYNOPSIS
    Merge a release branch with 'develop' and 'master' and delete the release branch.
    
    .DESCRIPTION
    When the release branch is ready to become a real release, it is merged with 'master' and 'master' is tagged with 
    the version number. The branch is also merged with 'develop'. The release is done, so the branch is deleted.
    
    .PARAMETER version
    The version of the release to finish.
    
    .NOTES
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
    
    # TODO: check for remote/master first
    git push origin master
    
    git checkout develop
    git merge --no-ff $releaseBranch
    git branch -d $releaseBranch
    
    # TODO: check for remote/develop first
    git push origin develop
}

Export-ModuleMember -Function Init-GitFlow
Export-ModuleMember -Function Start-Feature
Export-ModuleMember -Function Finish-Feature
Export-ModuleMember -Function Start-Release
Export-ModuleMember -Function Finish-Release