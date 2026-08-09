using System.Collections.Generic;

namespace ScrambleLib;

public class ScrambleNetResponse
{
	public enum ResponseType
	{
		GenericError,
		Success,
		Banner,
		Timeout,
		InvalidCredentials,
		SizeLimitExceeded,
		UnknownCommand,
		AccessDenied
	}

	private static Dictionary<string, ResponseType> _CodeToMessageType;

	private static Dictionary<ResponseType, string> _MessageTypeToCode;

	public ResponseType Type { get; set; }

	public string Data { get; set; }

	public ScrambleNetResponse()
	{
		Data = string.Empty;
	}

	public ScrambleNetResponse(ResponseType MsgType)
	{
		Data = string.Empty;
		Type = MsgType;
	}

	public ScrambleNetResponse(ResponseType MsgType, string MsgData)
	{
		Data = string.Empty;
		Type = MsgType;
		Data = MsgData;
	}

	public string GetErrorDescription()
	{
		return Type switch
		{
			ResponseType.AccessDenied => "Access is denied", 
			ResponseType.GenericError => string.IsNullOrEmpty(Data) ? "Unknown error" : Data, 
			_ => Type.ToString(), 
		};
	}

	public static string GetCodeFromMessageType(ResponseType MsgType)
	{
		if (_MessageTypeToCode == null)
		{
			_MessageTypeToCode = new Dictionary<ResponseType, string>();
			_MessageTypeToCode.Add(ResponseType.GenericError, "ERROR_GENERAL");
			_MessageTypeToCode.Add(ResponseType.Success, "SUCCESS");
			_MessageTypeToCode.Add(ResponseType.Banner, "SCRAMBLECORP_ORDERS_V1.0.3");
			_MessageTypeToCode.Add(ResponseType.Timeout, "SESSION_TIMED_OUT");
			_MessageTypeToCode.Add(ResponseType.SizeLimitExceeded, "ERROR_SIZE_LIMIT_EXCEEDED");
			_MessageTypeToCode.Add(ResponseType.UnknownCommand, "ERROR_UNKNOWN_COMMAND");
			_MessageTypeToCode.Add(ResponseType.AccessDenied, "ERROR_ACCESS_DENIED");
			_MessageTypeToCode.Add(ResponseType.InvalidCredentials, "ERROR_INVALID_CREDENTIALS");
		}
		return _MessageTypeToCode[MsgType];
	}

	public static ResponseType GetMessageTypeFromCode(string Code)
	{
		if (_CodeToMessageType == null)
		{
			_CodeToMessageType = new Dictionary<string, ResponseType>();
			_CodeToMessageType.Add("ERROR_GENERAL", ResponseType.GenericError);
			_CodeToMessageType.Add("SUCCESS", ResponseType.Success);
			_CodeToMessageType.Add("SCRAMBLECORP_ORDERS_V1.0.3", ResponseType.Banner);
			_CodeToMessageType.Add("SESSION_TIMED_OUT", ResponseType.Timeout);
			_CodeToMessageType.Add("ERROR_SIZE_LIMIT_EXCEEDED", ResponseType.SizeLimitExceeded);
			_CodeToMessageType.Add("ERROR_UNKNOWN_COMMAND", ResponseType.UnknownCommand);
			_CodeToMessageType.Add("ERROR_ACCESS_DENIED", ResponseType.AccessDenied);
			_CodeToMessageType.Add("ERROR_INVALID_CREDENTIALS", ResponseType.InvalidCredentials);
		}
		return _CodeToMessageType[Code];
	}

	public static ScrambleNetResponse FromString(string Message)
	{
		string[] array = Message.TrimEnd(new char[0]).Split(new char[1] { ';' });
		ScrambleNetResponse scrambleNetResponse = new ScrambleNetResponse();
		scrambleNetResponse.Type = GetMessageTypeFromCode(array[0]);
		Log.Write("Response type = " + scrambleNetResponse.Type);
		if (array.Length == 2)
		{
			scrambleNetResponse.Data = array[1];
		}
		return scrambleNetResponse;
	}
}
