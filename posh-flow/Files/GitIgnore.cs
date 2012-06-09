using System;
using System.IO;

namespace poshflow.Files
{
    public class GitIgnore
    {
        public string Fullpath { get; private set; }

        public GitIgnore(string path)
        {
            Fullpath = Path.Combine(path, ".gitignore");
        }

        public void Add(string token)
        {
            File.AppendAllText(Fullpath, string.Format("{0}{1}", token, Environment.NewLine));
        }
    }
}