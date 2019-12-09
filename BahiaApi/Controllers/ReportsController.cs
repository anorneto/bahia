using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using BahiaApi.Models;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace BahiaApi.Controllers
{

    [Route("api/reports")]
    [ApiController]
    public class ReportsController : ControllerBase
    {
        private readonly ReportContext _context;

        public ReportsController(ReportContext context)
        {
            _context = context;
        }

        // GET: api/reports
        // Lista as planilhas salvas no banco de dados
        [HttpGet]
        public async Task<ActionResult<IEnumerable<string>>> ListReports()
        {
            List<string> reportsDescriptions = new List<string> { };
            await Task.Run(() =>
            {
                foreach (Report report in _context.Reports)
                    reportsDescriptions.Add(report.Description);
            });
            return reportsDescriptions;
        }

        // GET: api/reports/nomedaplanilha
        [HttpGet("{description}")]
        public async Task<ActionResult<string>> GetReport(string description)
        {
            Report report = await _context.Reports.FindAsync(description);

            if (report == null)
            {
                return NotFound();
            }

            JObject json = JObject.Parse(report.Table);
            return Content(json.ToString(), "application/json");
        }

        // PUT: api/reports/nomedaplanilha
        // Atualiza a planilha {nomedaplanilha} com o novo json passado no body do PUT
        [HttpPut("{description}")]
        public async Task<IActionResult> UpdateReport(string description, [FromBody]string table)
        {
            Report report = new Report(Description: description, Table: table);
            if (description != report.Description)
            {
                return BadRequest();
            }

            _context.Entry(report).State = EntityState.Modified;

            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateConcurrencyException)
            {
                if (!ReportExists(description))
                {
                    return NotFound();
                }
                else
                {
                    throw;
                }
            }

            return Ok($"{description} ATUALIZADA");
        }

        // POST: api/reports/nomedaplanilha
        // Insere planilha com nome = {nomedaplanilha} e json passado pelo body do POST
        [HttpPost("{description}")]
        public async Task<ActionResult<Report>> AddReport(string description, [FromBody]string table)
        {
            Report report = new Report(Description: description, Table: JObject.Parse(table).ToString());
            _context.Reports.Add(report);
            try
            {
                await _context.SaveChangesAsync();
            }
            catch (DbUpdateException)
            {
                if (ReportExists(report.Description))
                {
                    return Conflict($"{description} Já Existe, Utilize PUT para atualizá-la");
                }
                else
                {
                    throw;
                }
            }

            return CreatedAtAction("GetReport", new { description = report.Description }, report);
        }

        // DELETE: api/reports/nomedaplanilha
        // Deleta planilha {nomedaplanilha}
        [HttpDelete("{description}")]
        public async Task<ActionResult<string>> DeleteReport(string description)
        {
            var report = await _context.Reports.FindAsync(description);
            if (report == null)
            {
                return NotFound();
            }

            _context.Reports.Remove(report);
            await _context.SaveChangesAsync();

            return Ok($"{description} DELETADA");
        }

        private bool ReportExists(string description)
        {
            return _context.Reports.Any(e => e.Description == description);
        }
    }
}
