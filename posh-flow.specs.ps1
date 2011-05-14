$pwd = Split-Path -Parent $MyInvocation.MyCommand.Path
. "$pwd\..\Pester\Pester.ps1"

Update-TypeData -pre "$pwd\..\Pester\ObjectAdaptations\types.ps1xml" -ErrorAction SilentlyContinue

Describe "When importing the posh-flow module" {
    Setup
    
    Import-Module posh-flow | Out-Null
    git init $TestDrive | Out-Null

    It "should import the Get-GitDirectory function" {
        $expected = Join-Path $TestDrive ".git"
        (Get-GitDirectory).should.be($expected)
    }
    
    It "should import the Get-GitBranch function" { 
        $expected = "(master)"
        (Get-GitBranch).should.be($expected)
    }
}

Describe "When initializing posh-flow in an empty repository" {
    Setup
    
    Import-Module posh-flow | Out-Null
    Init-GitFlow | Out-Null
    
    It "should initialize the git repo" {
        ".git".should.exist()
    }
    
    It "should create an empty readme" {
        "readme.markdown".should.exist()
    }
    
    It "should create an empty .gitignore" {
        ".gitignore".should.exist()
    }
    
    It "should commit the initial repository" {
    }
}