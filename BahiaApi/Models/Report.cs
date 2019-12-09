using System;
using System.ComponentModel.DataAnnotations;

namespace BahiaApi.Models
{
    public class Report
    {
        [Key]
        public string Description { get; set; }
        public string Table { get; set; }

        public Report(string Description, string Table)
        {
            this.Description = Description;
            this.Table = Table;
        }
    }
}
