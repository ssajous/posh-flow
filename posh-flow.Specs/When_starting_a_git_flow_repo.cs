using Machine.Specifications;

namespace poshflow.Specs
{
    [Subject(typeof(StartGitFlow))]
    public class When_starting_a_git_flow_repo
    {
        Because of = () => _cmdlet.Invoke();

        It should_do_something;

        private static StartGitFlow _cmdlet = new StartGitFlow();
    }
}
