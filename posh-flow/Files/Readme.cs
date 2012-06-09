using System.IO;

namespace poshflow.Files
{
    public class Readme
    {
        public string Fullpath { get; private set; }

        public Readme(string path)
        {
            Fullpath = Path.Combine(path, "readme.markdown");
        }

        public void WriteAllText(string format, params object[] args)
        {
            File.WriteAllText(Fullpath, string.Format(format, args));
        }
    }
}