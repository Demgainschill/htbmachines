using System.Threading;
using System.Threading.Tasks;
using MatthiWare.CommandLine.Abstractions.Command;
using UserInfo.Services;

namespace UserInfo.Commands;

public class FindUser : Command<GlobalOptions, FindUserOptions>
{
	public override void OnConfigure(ICommandConfigurationBuilder builder)
	{
		builder.Name("find").Description("Find a user");
	}

	public override async Task OnExecuteAsync(GlobalOptions options, FindUserOptions commandOptions, CancellationToken cancellationToken)
	{
		new LdapQuery().query(commandOptions.FirstName, commandOptions.LastName, options.Verbose);
	}
}
