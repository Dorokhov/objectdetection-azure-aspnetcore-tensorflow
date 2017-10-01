using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using System.Drawing;
using Microsoft.Extensions.Logging;

namespace objectdetection.Controllers
{
    [Route("api/[controller]")]
    public class ValuesController : Controller
    {
        private ILogger<ValuesController> _logger;
        public ValuesController(ILogger<ValuesController> logger)
        {
            _logger = logger;
        }
        // GET api/values
        [HttpGet]
        public IEnumerable<string> Get()
        {
            _logger.LogInformation("GGGGGETTTT");
            try
            {
                ExampleObjectDetection.Program.Main(new string[0], _logger);

            }
            catch(Exception ex)
            {
                _logger.LogInformation(ex.Message);
                _logger.LogInformation(ex?.InnerException.Message);
                _logger.LogInformation(ex?.InnerException?.InnerException.Message);
                
                throw;
            }
            return new string[] { "value1", "value2" };
        }

        // GET api/values/5
        [HttpGet("{id}")]
        public string Get(int id)
        {
            _logger.LogInformation("VVVAAALLLUUE");
            return "value";
        }

        // POST api/values
        [HttpPost]
        public void Post([FromBody]string value)
        {
        }

        // PUT api/values/5
        [HttpPut("{id}")]
        public void Put(int id, [FromBody]string value)
        {
        }

        // DELETE api/values/5
        [HttpDelete("{id}")]
        public void Delete(int id)
        {
        }
    }
}
