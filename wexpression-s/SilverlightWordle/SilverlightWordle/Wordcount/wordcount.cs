using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace SilverlightWordle
{
    public class wordcount
    {
        /// <summary>
        /// Count the number of words in the string using regular expression.
        /// </summary>
        /// <param name="textIn">The string you want a word count of.</param>
        /// <returns>The number of words in the string.</returns>
        static public Dictionary<string, int> WordCounts(string textIn, int maxWords)
        {
            string strWord;
            Dictionary<string, int> Tags = new Dictionary<string, int>();
            Dictionary<string, int> Result = new Dictionary<string, int>();

            MatchCollection collection = Regex.Matches(textIn, @"[\S]+");
            foreach (Match m in collection)
            {
                if (m.Length < 15)
                {
                    strWord = textIn.Substring(m.Index, m.Length);
                    strWord = Regex.Replace(strWord, @"([^a-zA-Z]|^\s)", string.Empty);
                    if (strWord.Length > 3)
                    {
                        if (!Tags.ContainsKey(strWord))
                            Tags.Add(strWord, 1);
                        else
                            Tags[strWord]++;
                    }
                }
            }

            var items = from k in Tags.Keys
                        orderby Tags[k] descending
                        select k;

            int i = 0;
            foreach (string k in items)
            {
                Result.Add(k, Tags[k]);
                if (i >= maxWords - 1)
                {
                    break;
                }
                else
                {
                    i++;
                }
            }

            return Result;
        }

        public static string ClearHTMLTags(string source)
        {
            return Regex.Replace(source, @"<(.|\n)*?>", string.Empty);
        }
    }
}
