using System;
using System.Collections.Generic;
using System.IO;
using System.Net.Sockets;
using System.Security.Cryptography;
using System.Text;
using Microsoft.VisualBasic.CompilerServices;

namespace ScrambleLib;

public class ScrambleNetClient
{
	private const int NetworkReadTimeout = 20;

	public string Server { get; set; }

	public int Port { get; set; }

	public ScrambleNetClient()
	{
		Server = string.Empty;
		Port = 4411;
	}

	public bool Logon(string Username, string Password)
	{
		try
		{
			if (string.Compare(Username, "scrmdev", ignoreCase: true) == 0)
			{
				Log.Write("Developer logon bypass used");
				return true;
			}
			MD5 mD = MD5.Create();
			byte[] bytes = Encoding.ASCII.GetBytes(Password);
			Convert.ToBase64String(mD.ComputeHash(bytes, 0, bytes.Length));
			ScrambleNetResponse scrambleNetResponse = SendRequestAndGetResponse(new ScrambleNetRequest(ScrambleNetRequest.RequestType.AuthenticationRequest, Username + "|" + Password));
			switch (scrambleNetResponse.Type)
			{
			case ScrambleNetResponse.ResponseType.Success:
				Log.Write("Logon successful");
				return true;
			case ScrambleNetResponse.ResponseType.InvalidCredentials:
				Log.Write("Logon failed due to invalid credentials");
				return false;
			default:
				throw new ApplicationException(scrambleNetResponse.GetErrorDescription());
			}
		}
		catch (Exception ex)
		{
			ProjectData.SetProjectError(ex);
			Exception ex2 = ex;
			Log.Write("Error: " + ex2.Message);
			throw ex2;
		}
	}

	public List<SalesOrder> GetOrders()
	{
		try
		{
			Log.Write("Getting orders from server");
			ScrambleNetResponse scrambleNetResponse = SendRequestAndGetResponse(new ScrambleNetRequest(ScrambleNetRequest.RequestType.ListOrders, null));
			if (scrambleNetResponse.Type == ScrambleNetResponse.ResponseType.Success)
			{
				List<SalesOrder> list = new List<SalesOrder>();
				if (!string.IsNullOrWhiteSpace(scrambleNetResponse.Data))
				{
					Log.Write("Splitting and parsing sales orders");
					string[] array = scrambleNetResponse.Data.TrimEnd(new char[0]).Split(new char[1] { '|' });
					Log.Write("Found " + Conversions.ToString(array.Length) + " sales orders in server response");
					string[] array2 = array;
					foreach (string text in array2)
					{
						Log.Write("Deserializing single sales order from base64: " + text);
						list.Add(SalesOrder.DeserializeFromBase64(text));
						Log.Write("Deserialization successful");
					}
					Log.Write("Finished deserializing all sales orders");
				}
				return list;
			}
			throw new ApplicationException(scrambleNetResponse.GetErrorDescription());
		}
		catch (Exception ex)
		{
			ProjectData.SetProjectError(ex);
			Exception ex2 = ex;
			Log.Write("Error: " + ex2.Message);
			throw ex2;
		}
	}

	public void UploadOrder(SalesOrder NewOrder)
	{
		try
		{
			Log.Write("Uploading new order with reference " + NewOrder.ReferenceNumber);
			string text = NewOrder.SerializeToBase64();
			Log.Write("Order serialized to base64: " + text);
			ScrambleNetResponse scrambleNetResponse = SendRequestAndGetResponse(new ScrambleNetRequest(ScrambleNetRequest.RequestType.UploadOrder, text));
			ScrambleNetResponse.ResponseType type = scrambleNetResponse.Type;
			if (type == ScrambleNetResponse.ResponseType.Success)
			{
				Log.Write("Upload successful");
				return;
			}
			throw new ApplicationException(scrambleNetResponse.GetErrorDescription());
		}
		catch (Exception ex)
		{
			ProjectData.SetProjectError(ex);
			Exception ex2 = ex;
			Log.Write("Error: " + ex2.Message);
			throw ex2;
		}
	}

	private ScrambleNetResponse SendRequestAndGetResponse(ScrambleNetRequest Request)
	{
		Log.Write("Connecting to server");
		TcpClient tcpClient = new TcpClient();
		tcpClient.ReceiveTimeout = checked((int)Math.Round(TimeSpan.FromSeconds(20.0).TotalMilliseconds));
		tcpClient.ReceiveBufferSize = 2048;
		tcpClient.SendBufferSize = 2048;
		tcpClient.Connect(Server, Port);
		try
		{
			using NetworkStream networkStream = tcpClient.GetStream();
			using StreamWriter streamWriter = new StreamWriter(networkStream, Encoding.ASCII);
			streamWriter.AutoFlush = true;
			if (GetResponse(networkStream).Type != ScrambleNetResponse.ResponseType.Banner)
			{
				throw new ApplicationException("Unexpected response from server on initial connection");
			}
			string text = ScrambleNetRequest.GetCodeFromMessageType(Request.Type) + ";" + Request.Parameter + "\n";
			Log.Write("Sending data to server: " + text);
			streamWriter.Write(text);
			Log.Write("Getting response from server");
			ScrambleNetResponse response = GetResponse(networkStream);
			try
			{
				byte[] bytes = Encoding.ASCII.GetBytes("QUIT\n");
				networkStream.Write(bytes, 0, bytes.Length);
				networkStream.Close();
			}
			catch (Exception ex)
			{
				ProjectData.SetProjectError(ex);
				Exception ex2 = ex;
				Log.Write("Error sending QUIT and closing stream: " + ex2.Message);
				ProjectData.ClearProjectError();
			}
			return response;
		}
		finally
		{
			try
			{
				tcpClient.Close();
			}
			catch (Exception ex3)
			{
				ProjectData.SetProjectError(ex3);
				Exception ex4 = ex3;
				Log.Write("Error closing TCP connection: " + ex4.Message);
				ProjectData.ClearProjectError();
			}
		}
	}

	private ScrambleNetResponse GetResponse(NetworkStream NetStream)
	{
		StringBuilder stringBuilder = new StringBuilder();
		byte[] array = new byte[4096];
		NetStream.ReadTimeout = checked((int)Math.Round(TimeSpan.FromSeconds(20.0).TotalMilliseconds));
		string @string;
		do
		{
			int num = NetStream.Read(array, 0, array.Length);
			if (num == 0)
			{
				break;
			}
			@string = Encoding.ASCII.GetString(array, 0, num);
			stringBuilder.Append(@string);
		}
		while (!@string.EndsWith("\n"));
		string text = stringBuilder.ToString();
		if (string.IsNullOrWhiteSpace(text))
		{
			throw new ApplicationException("No data received from server");
		}
		Log.Write("Received from server: " + text);
		Log.Write("Parsing server response");
		return ScrambleNetResponse.FromString(text);
	}
}
