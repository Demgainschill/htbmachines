using MatthiWare.CommandLine.Core.Attributes;

namespace UserInfo;

public class FindUserOptions
{
	[Name("first")]
	[Description("First name")]
	public string FirstName { get; set; }

	[Name("last")]
	[Description("Last name")]
	public string LastName { get; set; }
}
