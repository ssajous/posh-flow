using System.IO;
using LibGit2Sharp;
using PowerShell = System.Management.Automation;

namespace poshflow
{
    [PowerShell.Cmdlet(PowerShell.VerbsLifecycle.Start, "GitFlow")]
    public class StartGitFlow : PowerShell.Cmdlet
    {
        private readonly string _container;
        private readonly Repository _repository;

        public StartGitFlow()
        {
            _container = Path.GetDirectoryName(".");
            _repository = new Repository(".git");
        }

        protected override void ProcessRecord()
        {
            File.WriteAllText("readme.markdown", "# {0}".InlineFormat(_container));
            File.WriteAllText(".gitignore", "");

            _repository.Index.Stage("readme.markdown");
            _repository.Index.Stage(".gitignore");

            _repository.Commit("Initialized a git-flow repository: {0}".InlineFormat(_container));
        }
    }
}
