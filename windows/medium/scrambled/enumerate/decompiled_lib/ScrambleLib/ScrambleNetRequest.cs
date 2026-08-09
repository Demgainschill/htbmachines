using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.VisualBasic.CompilerServices;

namespace ScrambleLib;

public class ScrambleNetRequest
{
	public enum RequestType
	{
		AuthenticationRequest,
		ListOrders,
		UploadOrder,
		CloseConnection
	}

	public class UnrecognisedCommandException : ApplicationException
	{
	}

	private static Dictionary<string, RequestType> _CodeToMessageType;

	private static Dictionary<RequestType, string> _MessageTypeToCode;

	public RequestType Type { get; set; }

	public string Parameter { get; set; }

	public ScrambleNetRequest()
	{
		Parameter = string.Empty;
	}

	public ScrambleNetRequest(RequestType MsgType)
	{
		Parameter = string.Empty;
		Type = MsgType;
	}

	public ScrambleNetRequest(RequestType MsgType, string MsgParam)
	{
		Parameter = string.Empty;
		Type = MsgType;
		Parameter = MsgParam;
	}

	public static string GetCodeFromMessageType(RequestType MsgType)
	{
		if (_MessageTypeToCode == null)
		{
			_MessageTypeToCode = new Dictionary<RequestType, string>();
			_MessageTypeToCode.Add(RequestType.CloseConnection, "QUIT");
			_MessageTypeToCode.Add(RequestType.ListOrders, "LIST_ORDERS");
			_MessageTypeToCode.Add(RequestType.AuthenticationRequest, "LOGON");
			_MessageTypeToCode.Add(RequestType.UploadOrder, "UPLOAD_ORDER");
		}
		return _MessageTypeToCode[MsgType];
	}

	public static RequestType GetMessageTypeFromCode(string Code)
	{
		if (_CodeToMessageType == null)
		{
			_CodeToMessageType = new Dictionary<string, RequestType>();
			_CodeToMessageType.Add("QUIT", RequestType.CloseConnection);
			_CodeToMessageType.Add("LIST_ORDERS", RequestType.ListOrders);
			_CodeToMessageType.Add("UPLOAD_ORDER", RequestType.UploadOrder);
			_CodeToMessageType.Add("LOGON", RequestType.AuthenticationRequest);
		}
		if (!_CodeToMessageType.ContainsKey(Code))
		{
			throw new UnrecognisedCommandException();
		}
		return _CodeToMessageType[Code];
	}

	public static ScrambleNetRequest FromString(string MessageData)
	{
		if (string.IsNullOrWhiteSpace(MessageData))
		{
			throw new ApplicationException("Empty network message");
		}
		ScrambleNetRequest scrambleNetRequest = new ScrambleNetRequest();
		string[] array = MessageData.TrimEnd(new char[0]).Split(new char[1] { ';' });
		string text = array[0];
		scrambleNetRequest.Type = GetMessageTypeFromCode(text);
		if (Operators.CompareString(text, "QUIT", false) != 0 && array.Count() == 2)
		{
			scrambleNetRequest.Parameter = array[1];
		}
		return scrambleNetRequest;
	}
}
