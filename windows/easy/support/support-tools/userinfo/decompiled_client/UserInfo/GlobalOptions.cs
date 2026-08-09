using MatthiWare.CommandLine.Core.Attributes;

namespace UserInfo;

public class GlobalOptions
{
	[Name("v", "verbose")]
	[DefaultValue(false)]
	[Description("Verbose output")]
	public bool Verbose { get; set; }
}
