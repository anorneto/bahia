using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;

namespace BahiaApi.Models
{
    public class ReportContext : DbContext
    {
        public ReportContext(DbContextOptions<ReportContext> options) : base(options)
        {
        }

        public DbSet<Report> Reports { get; set; }
    }

}
