//using NLog;
//using NLog.Extensions.Logging;
//using NLog.Web;
//using NLog.Targets;
//using NLog.Config;
using Microsoft.Extensions.Logging;

namespace objectdetection
{
    public static class FileLoggerExtensions
    {
        public static ILoggerFactory AddFile(this ILoggerFactory factory, string filePath)
        {
            factory.AddProvider(new FileLoggerProvider(filePath));
            return factory;
        }
    }
}
