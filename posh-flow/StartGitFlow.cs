using System.IO;
using LibGit2Sharp;
using poshflow.Files;
using PowerShell = System.Management.Automation;

namespace poshflow
{
    [PowerShell.Cmdlet(PowerShell.VerbsLifecycle.Start, "GitFlow")]
    public class StartGitFlow : PowerShell.Cmdlet
    {
        [PowerShell.Parameter(Position = 0, ValueFromPipeline = true)]
        [PowerShell.ValidateNotNullOrEmpty]
        public string Name { get; set; }

        public string Fullpath
        {
            get { return Path.GetFullPath(string.IsNullOrEmpty(Name) ? "." : Name); }
        }
        
        public string Container
        {
            get { return Path.GetFileName(Fullpath); }
        }

        public StartGitFlow()
        {
            Name = "";
        }

        protected override void ProcessRecord()
        {
            var gitpath = Repository.Init(Fullpath);
            var repository = new Repository(gitpath);

            var readme = new Readme(Fullpath);
            readme.WriteAllText("# {0}", Container);

            var gitignore = new GitIgnore(Fullpath);
            gitignore.Add("");

            repository.Index.Stage(readme.Fullpath);
            repository.Index.Stage(gitignore.Fullpath);

            repository.Commit(string.Format("Initialized a git-flow repository: {0}", Container));

            var master = repository.Branches[GitFlow.Master];

            repository.Branches.Create(GitFlow.Develop, master.CanonicalName);
            repository.Branches.Checkout(GitFlow.Develop);
        }
    }
}