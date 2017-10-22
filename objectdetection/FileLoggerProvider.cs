//using NLog;
//using NLog.Extensions.Logging;
//using NLog.Web;
//using NLog.Targets;
//using NLog.Config;
using Microsoft.Extensions.Logging;

namespace objectdetection
{
    public class FileLoggerProvider : ILoggerProvider
    {
        private string path;
        public FileLoggerProvider(string _path)
        {
            path = _path;
        }
        public ILogger CreateLogger(string categoryName)
        {
            return new FileLogger(path);
        }

        public void Dispose()
        {
        }
    }
}
