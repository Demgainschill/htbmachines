using System;
using System.IO;
using Microsoft.VisualBasic;
using Microsoft.VisualBasic.CompilerServices;

namespace ScrambleLib;

public class Log
{
	private static string _LogFilePath;

	public static bool LoggingEnabled { get; set; }

	public static string LogFilePath
	{
		get
		{
			string result;
			if (_LogFilePath == null)
			{
				try
				{
					_LogFilePath = Path.Combine(Environment.CurrentDirectory, "ScrambleDebugLog.txt");
				}
				catch (Exception ex)
				{
					ProjectData.SetProjectError(ex);
					Exception ex2 = ex;
					result = "ScrambleDebugLog.txt";
					ProjectData.ClearProjectError();
					goto IL_0037;
				}
			}
			result = _LogFilePath;
			goto IL_0037;
			IL_0037:
			return result;
		}
	}

	public static void Write(string Message)
	{
		try
		{
			if (LoggingEnabled)
			{
				File.AppendAllText(LogFilePath, DateAndTime.Now.ToString() + "\t" + Message.Trim() + Environment.NewLine);
			}
		}
		catch (Exception ex)
		{
			ProjectData.SetProjectError(ex);
			Exception ex2 = ex;
			ProjectData.ClearProjectError();
		}
	}
}
