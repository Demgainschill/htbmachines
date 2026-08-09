using System.ServiceModel;

[ServiceContract]
public interface IMonitoringService
{
	[OperationContract]
	string StartMonitoring();

	[OperationContract]
	string StopMonitoring();

	[OperationContract]
	string KillProcess(string processName);
}
