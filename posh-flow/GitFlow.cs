using System;

namespace poshflow
{
    public static class GitFlow
    {
        public const string Master = "master";
        public const string Develop = "develop";
        public static readonly Func<string, string> Feature = name => string.Format("feature/{0}", name);
        public static readonly Func<string, string> Release = name => string.Format("release-{0}", name);
    }
}