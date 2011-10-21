<#
    .SYNOPSIS
    Initialize a git-flow controlled repository.
    
    .DESCRIPTION
    The central repository holds two main branches with an infinite 
    lifetime: 'master' and 'develop'. The HEAD of 'origin/master' is 
    considered to be production ready code. The HEAD of 'origin/
    develop' is the features for the next release. This is where 
    automatic nightly builds would build from.
        
    .NOTES
    This function will initialize a directory as a git repository if 
    necessary. It will create a readme and a gitignore file and 
    commit them to start up the master branch.
#>
function Init-GitFlow 
{
    # TODO: Lots of choices
    #   1. brand new repo = git checkout -b develop master
    #   2. local develop = git checkout develop
    #   3. remote develop = git checkout develop origin/develop

    if(-not(Test-Path .git)) 
    {
        $repo = Get-Location | Split-Path -Leaf
        
        git init .
        Set-Content readme.markdown "# $repo"
        Set-Content .gitignore ""
        git add .
        git commit -a -m "initialized git-flow repository: $repo"
        git checkout -b develop master
        
        return
    }
    
    #if(@(git branch -a | Select-String "[^/]develop").Length -gt 0)
        #git checkout "develop"
    
    #$ctx = (git branch -a | Select-String "remotes/(\w+)/develop")
    #if($ctx.Matches.Length -gt 0)
        #git checkout -b "develop" ("{0}/develop" -f $ctx.Matches[0].Groups[1].Value)
}