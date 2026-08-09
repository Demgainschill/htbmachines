using System;
using System.Data.Common;
using System.Data.SQLite;
using System.Data.SqlClient;
using System.IO;
using System.ServiceModel;
using System.ServiceModel.Channels;
using System.Timers;

internal class Program
{
	private static void Main(string[] args)
	{
		//IL_000f: Unknown result type (might be due to invalid IL or missing references)
		//IL_0014: Unknown result type (might be due to invalid IL or missing references)
		ServiceHost val = new ServiceHost(typeof(MonitoringService), Array.Empty<Uri>());
		((CommunicationObject)val).Open();
		Console.WriteLine("Service is running...");
		Timer timer = new Timer(30000.0);
		timer.Elapsed += CheckEdgeHistory;
		timer.Start();
		Console.WriteLine("Press Enter to exit...");
		Console.ReadLine();
		((CommunicationObject)val).Close();
	}

	private static void CheckEdgeHistory(object sender, ElapsedEventArgs e)
	{
		//IL_002e: Unknown result type (might be due to invalid IL or missing references)
		//IL_0034: Expected O, but got Unknown
		//IL_003a: Unknown result type (might be due to invalid IL or missing references)
		//IL_0040: Expected O, but got Unknown
		//IL_0057: Unknown result type (might be due to invalid IL or missing references)
		//IL_005e: Expected O, but got Unknown
		//IL_006c: Unknown result type (might be due to invalid IL or missing references)
		string text = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData), "Microsoft\\Edge\\User Data\\Default\\History");
		if (!File.Exists(text))
		{
			return;
		}
		string tempFileName = Path.GetTempFileName();
		File.Copy(text, tempFileName, overwrite: true);
		try
		{
			SqlConnection val = new SqlConnection("Server=localhost;Database=SecurityLogs;User Id=sqlsvc;Password=TI0LKcfHzZw1Vv;");
			try
			{
				((DbConnection)(object)val).Open();
				SqlCommand val2 = new SqlCommand();
				try
				{
					val2.Connection = val;
					SQLiteConnection val3 = new SQLiteConnection("Data Source=" + tempFileName + ";Version=3;");
					((DbConnection)(object)val3).Open();
					SQLiteDataReader val4 = new SQLiteCommand("SELECT url, last_visit_time FROM urls ORDER BY last_visit_time DESC LIMIT 5", val3).ExecuteReader();
					while (((DbDataReader)(object)val4).Read())
					{
						string text2 = ((DbDataReader)(object)val4)["url"].ToString();
						string commandText = "INSERT INTO EventLog (Timestamp, EventType, Details) VALUES (GETDATE(), 'URLVisit', '" + text2 + "')";
						((DbCommand)(object)val2).CommandText = commandText;
						((DbCommand)(object)val2).ExecuteNonQuery();
					}
					((DbConnection)(object)val3).Close();
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
		catch
		{
		}
		finally
		{
			File.Delete(tempFileName);
		}
	}
}
