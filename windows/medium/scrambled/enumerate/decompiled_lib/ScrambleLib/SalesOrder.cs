using System;
using System.Collections.Generic;
using System.IO;
using System.Runtime.Serialization.Formatters.Binary;
using Microsoft.VisualBasic.CompilerServices;

namespace ScrambleLib;

[Serializable]
public class SalesOrder
{
	public bool IsComplete { get; set; }

	public string ReferenceNumber { get; set; }

	public string QuoteReference { get; set; }

	public string SalesRep { get; set; }

	public List<string> OrderItems { get; set; }

	public DateTime DueDate { get; set; }

	public double TotalCost { get; set; }

	public string DueDateDisplayText => DueDate.ToShortDateString();

	public SalesOrder()
	{
		ReferenceNumber = string.Empty;
		QuoteReference = string.Empty;
		SalesRep = string.Empty;
		OrderItems = new List<string>();
	}

	public string SerializeToBase64()
	{
		BinaryFormatter binaryFormatter = new BinaryFormatter();
		Log.Write("Binary formatter init successful");
		using MemoryStream memoryStream = new MemoryStream();
		binaryFormatter.Serialize(memoryStream, this);
		return Convert.ToBase64String(memoryStream.ToArray());
	}

	public static SalesOrder DeserializeFromBase64(string Base64)
	{
		try
		{
			byte[] buffer = Convert.FromBase64String(Base64);
			BinaryFormatter binaryFormatter = new BinaryFormatter();
			Log.Write("Binary formatter init successful");
			using MemoryStream serializationStream = new MemoryStream(buffer);
			return (SalesOrder)binaryFormatter.Deserialize(serializationStream);
		}
		catch (Exception ex)
		{
			ProjectData.SetProjectError(ex);
			Exception ex2 = ex;
			throw new ApplicationException("Error deserializing sales order: " + ex2.Message);
		}
	}
}
