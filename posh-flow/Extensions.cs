namespace poshflow
{
    public static class Extensions
    {
        public static string InlineFormat(this string format, params object[] args)
        {
            return string.Format(format, args);
        }
    }
}