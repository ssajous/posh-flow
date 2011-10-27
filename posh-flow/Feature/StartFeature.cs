using System.IO;
using LibGit2Sharp;
using System.Management.Automation;

namespace poshflow.Feature
{
    [Cmdlet(VerbsLifecycle.Start, "Feature")]
    public class StartFeature : Cmdlet
    {
        [Parameter(Mandatory = true, Position = 0, ValueFromPipeline = true)]
        [ValidateNotNullOrEmpty]
        public string Name { get; set; }

        protected override void ProcessRecord()
        {
            var startingPath = Path.GetFullPath(".");
            var gitpath = Repository.Discover(startingPath);
            var repository = new Repository(gitpath);

            var feature = GitFlow.Feature(Name);
            var develop = repository.Branches[GitFlow.Develop];

            repository.Branches.Create(feature, develop.CanonicalName);
            repository.Branches.Checkout(feature);
        }
    }
}