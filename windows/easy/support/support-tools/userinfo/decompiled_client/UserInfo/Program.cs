using System.Reflection;
using System.Threading.Tasks;
using MatthiWare.CommandLine;

namespace UserInfo;

internal class Program
{
	private static async Task Main(string[] args)
	{
		CommandLineParser<GlobalOptions> commandLineParser = new CommandLineParser<GlobalOptions>(new CommandLineParserOptions
		{
			AppName = "UserInfo.exe"
		});
		commandLineParser.DiscoverCommands(Assembly.GetExecutingAssembly());
		_ = (await commandLineParser.ParseAsync(args)).HasErrors;
	}
}
