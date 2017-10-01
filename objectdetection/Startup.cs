using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;
using System.Reflection;
using System.IO;
using System.Collections.Concurrent;
using System.Threading;
using System.Text;
//using NLog;
//using NLog.Extensions.Logging;
//using NLog.Web;
//using NLog.Targets;
//using NLog.Config;
using Microsoft.Extensions.Logging;

namespace objectdetection
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddMvc();
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IHostingEnvironment env, Microsoft.Extensions.Logging.ILoggerFactory loggerFactory, IHostingEnvironment hostingEnvironment)
        {
            //add NLog to ASP.NET Core
            //ILoggerFactory l = loggerFactory.AddNLog();

            //var conf = new LoggingConfiguration()
            //{  
            //};


            //var ft = new FileTarget("mynlog")
            //{
            //    FileName = "${basedir}/mynlog.txt",
            //    AutoFlush = true,
            //    Layout = "${longdate}|${event-properties:item=EventId.Id}|${logger}|${uppercase:${level}}|  ${message} ${exception}|url: ${aspnet-request-url}|action: ${aspnet-mvc-action}",

            //};
            //conf.AddTarget(ft);

            //var rule1 = new LoggingRule("*", NLog.LogLevel.Debug, ft);
            ////config.LoggingRules.Add(rule1);
            //conf.LoggingRules.Add(rule1);


            //var cfg = loggerFactory.ConfigureNLog(conf);

            ////add NLog.Web
            //app.AddNLogWeb();

            loggerFactory.AddFile(Path.Combine(hostingEnvironment.ContentRootPath, "logger.txt"));

            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseMvc();
        }
    }

    public class FileLogger : ILogger
    {
        private string filePath;
        private object _lock = new object();
        public FileLogger(string path)
        {
            filePath = path;
        }
        public IDisposable BeginScope<TState>(TState state)
        {
            return null;
        }

        public bool IsEnabled(LogLevel logLevel)
        {
            //return logLevel == LogLevel.Trace;
            return true;
        }

        public void Log<TState>(LogLevel logLevel, EventId eventId, TState state, Exception exception, Func<TState, Exception, string> formatter)
        {
            if (formatter != null)
            {
                lock (_lock)
                {
                    File.AppendAllText(filePath, formatter(state, exception) + Environment.NewLine);
                }
            }
        }
    }

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

    public static class FileLoggerExtensions
    {
        public static ILoggerFactory AddFile(this ILoggerFactory factory,
                                        string filePath)
        {
            factory.AddProvider(new FileLoggerProvider(filePath));
            return factory;
        }
    }
}
