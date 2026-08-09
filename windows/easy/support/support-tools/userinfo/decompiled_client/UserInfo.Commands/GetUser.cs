using System.Threading;
using System.Threading.Tasks;
using MatthiWare.CommandLine.Abstractions.Command;
using UserInfo.Services;

namespace UserInfo.Commands;

public class GetUser : Command<GlobalOptions, GetUserOptions>
{
	public override void OnConfigure(ICommandConfigurationBuilder builder)
	{
		builder.Name("user").Description("Get information about a user");
	}

	public override async Task OnExecuteAsync(GlobalOptions options, GetUserOptions commandOptions, CancellationToken cancellationToken)
	{
		new LdapQuery().printUser(commandOptions.UserName, options.Verbose);
	}
}
