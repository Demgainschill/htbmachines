using MatthiWare.CommandLine.Core.Attributes;

namespace UserInfo;

public class GetUserOptions
{
	[Name("username")]
	[Required(true)]
	[Description("Username")]
	public string UserName { get; set; }
}
