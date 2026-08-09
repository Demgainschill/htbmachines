using System;
using System.Collections.ObjectModel;
using System.Data.Common;
using System.Data.SqlClient;
using System.Management;
using System.Management.Automation;
using System.Management.Automation.Runspaces;
using System.Text;
using Microsoft.Win32;

public class MonitoringService : IMonitoringService
{
	private ManagementEventWatcher processStartWatcher;

	private bool isRunning;

	private readonly string connectionString = "Server=localhost;Database=SecurityLogs;User Id=sqlsvc;Password=TI0LKcfHzZw1Vv;";

	public string StartMonitoring()
	{
		//IL_0015: Unknown result type (might be due to invalid IL or missing references)
		//IL_001f: Expected O, but got Unknown
		if (isRunning)
		{
			return "Already monitoring.";
		}
		SystemEvents.SessionSwitch += new SessionSwitchEventHandler(SystemEvents_SessionSwitch);
		StartProcessWatcher();
		isRunning = true;
		return "Monitoring started.";
	}

	public string StopMonitoring()
	{
		//IL_0015: Unknown result type (might be due to invalid IL or missing references)
		//IL_001f: Expected O, but got Unknown
		if (!isRunning)
		{
			return "Monitoring not active.";
		}
		SystemEvents.SessionSwitch -= new SessionSwitchEventHandler(SystemEvents_SessionSwitch);
		processStartWatcher.Stop();
		isRunning = false;
		return "Monitoring stopped.";
	}

	private void SystemEvents_SessionSwitch(object sender, SessionSwitchEventArgs e)
	{
		//IL_0001: Unknown result type (might be due to invalid IL or missing references)
		//IL_0006: Unknown result type (might be due to invalid IL or missing references)
		SessionSwitchReason reason = e.Reason;
		string text = ((object)(SessionSwitchReason)(ref reason)).ToString();
		LogEvent("SessionSwitch", "Reason: " + text);
	}

	private void StartProcessWatcher()
	{
		//IL_0005: Unknown result type (might be due to invalid IL or missing references)
		//IL_000b: Expected O, but got Unknown
		//IL_000d: Unknown result type (might be due to invalid IL or missing references)
		//IL_0017: Expected O, but got Unknown
		//IL_0024: Unknown result type (might be due to invalid IL or missing references)
		//IL_002e: Expected O, but got Unknown
		WqlEventQuery val = new WqlEventQuery("SELECT * FROM Win32_ProcessStartTrace");
		processStartWatcher = new ManagementEventWatcher((EventQuery)(object)val);
		processStartWatcher.EventArrived += (EventArrivedEventHandler)delegate(object sender, EventArrivedEventArgs e)
		{
			string text = e.NewEvent.Properties["ProcessName"].Value.ToString();
			LogEvent("ProcessStart", "Process: " + text);
		};
		processStartWatcher.Start();
	}

	private void LogEvent(string type, string detail)
	{
		//IL_0006: Unknown result type (might be due to invalid IL or missing references)
		//IL_000c: Expected O, but got Unknown
		//IL_0038: Unknown result type (might be due to invalid IL or missing references)
		//IL_0048: Expected O, but got Unknown
		SqlConnection val = new SqlConnection(connectionString);
		try
		{
			SqlCommand val2 = new SqlCommand("INSERT INTO EventLog (Timestamp, EventType, Details) VALUES (GETDATE(), '" + type + "', '" + detail + "')", val);
			((DbConnection)(object)val).Open();
			((DbCommand)val2).ExecuteNonQuery();
		}
		finally
		{
			((IDisposable)val)?.Dispose();
		}
	}

	public string KillProcess(string processName)
	{
		string text = "Stop-Process -Name " + processName + " -Force";
		try
		{
			Runspace val = RunspaceFactory.CreateRunspace();
			try
			{
				val.Open();
				Pipeline val2 = val.CreatePipeline();
				try
				{
					val2.Commands.AddScript(text);
					val2.Commands.Add("Out-String");
					Collection<PSObject> collection = val2.Invoke();
					val.Close();
					StringBuilder stringBuilder = new StringBuilder();
					foreach (PSObject item in collection)
					{
						stringBuilder.AppendLine(((object)item).ToString());
					}
					return stringBuilder.ToString();
				}
				finally
				{
					((IDisposable)val2)?.Dispose();
				}
			}
			finally
			{
				((IDisposable)val)?.Dispose();
			}
		}
		catch (Exception ex)
		{
			return "Error: " + ex.Message;
		}
	}
}
