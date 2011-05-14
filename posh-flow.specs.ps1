######################################################################
# Import Pester
######################################################################
. ..\Pester\Pester.ps1
Update-TypeData -pre ..\Pester\ObjectAdaptations\types.ps1xml -ErrorAction SilentlyContinue
######################################################################

Import-Module posh-flow | Out-Null

Describe "When importing the posh-flow module" {
    Setup
    Push-Location $TestDrive
    git init $TestDrive | Out-Null

    It "should import the Get-GitDirectory function" {
        $expected = Join-Path $TestDrive ".git"
        $actual = Get-GitDirectory
        $actual.should.be($expected)
    }
    
    It "should import the Get-GitBranch function" { 
        $expected = "(master)"
        $actual = Get-GitBranch
        $actual.should.be($expected)
    }
    
    Pop-Location
}

Describe "When initializing posh-flow in an empty repository" {
    Setup
    Push-Location $TestDrive
    Init-GitFlow | Out-Null
    
    It "should initialize the git repo" {
        $expected = Join-Path $TestDrive ".git"
        $expected.should.exist()
    }
    
    It "should create an empty readme" {
        $expected = Join-Path $TestDrive "readme.markdown"
        $expected.should.exist()
    }
    
    It "should create an empty .gitignore" {
        $expected = Join-Path $TestDrive ".gitignore"
        $expected.should.exist()
    }
    
    It "should commit the initial repository" {
        $expected = git log $TestDrive `
            | Select-String "initialized repository" `
            | Measure-Object
        $expected.Count.should.be(1)
    }
    
    Pop-Location
}