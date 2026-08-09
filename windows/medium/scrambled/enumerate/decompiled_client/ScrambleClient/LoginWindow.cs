using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.IO;
using System.Net;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Timers;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Documents;
using System.Windows.Markup;
using System.Windows.Threading;
using Microsoft.VisualBasic.CompilerServices;
using ScrambleClient.My;
using ScrambleLib;

namespace ScrambleClient;

[DesignerGenerated]
public class LoginWindow : Window, IComponentConnector
{
	private ScrambleNetClient _Client;

	private int _AttempCount;

	private System.Timers.Timer _LockoutTimer;

	private AutoResetEvent _NetworkTimeout;

	private string _ConfigPath;

	[CompilerGenerated]
	[AccessedThroughProperty("SignInBtn")]
	private Button _SignInBtn;

	private bool _contentLoaded;

	[field: AccessedThroughProperty("MainGrid")]
	internal virtual Grid MainGrid
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("ServerLbl")]
	internal virtual TextBlock ServerLbl
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("EditServerLink")]
	internal virtual Hyperlink EditServerLink
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("UsernameBox")]
	internal virtual TextBox UsernameBox
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("PassBox")]
	internal virtual PasswordBox PassBox
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	internal virtual Button SignInBtn
	{
		[CompilerGenerated]
		get
		{
			return _SignInBtn;
		}
		[MethodImpl(MethodImplOptions.Synchronized)]
		[CompilerGenerated]
		set
		{
			//IL_0007: Unknown result type (might be due to invalid IL or missing references)
			//IL_000d: Expected O, but got Unknown
			RoutedEventHandler val = new RoutedEventHandler(SignInBtn_Click);
			Button signInBtn = _SignInBtn;
			if (signInBtn != null)
			{
				((ButtonBase)signInBtn).Click -= val;
			}
			_SignInBtn = value;
			signInBtn = _SignInBtn;
			if (signInBtn != null)
			{
				((ButtonBase)signInBtn).Click += val;
			}
		}
	}

	[field: AccessedThroughProperty("ProgressPanel")]
	internal virtual StackPanel ProgressPanel
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("Spacer")]
	internal virtual Border Spacer
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	public LoginWindow()
	{
		//IL_000e: Unknown result type (might be due to invalid IL or missing references)
		//IL_0018: Expected O, but got Unknown
		((FrameworkElement)this).Loaded += new RoutedEventHandler(Window_Loaded);
		_Client = new ScrambleNetClient
		{
			Port = 4411
		};
		_LockoutTimer = new System.Timers.Timer(TimeSpan.FromSeconds(10.0).TotalMilliseconds);
		_NetworkTimeout = new AutoResetEvent(initialState: false);
		_ConfigPath = Path.Combine(MyWpfExtension.Application.Info.DirectoryPath, "config.ini");
		InitializeComponent();
	}

	private void EditServerLink_Click(object sender, RoutedEventArgs e)
	{
		//IL_00d7: Unknown result type (might be due to invalid IL or missing references)
		OptionsWindow optionsWindow = new OptionsWindow();
		optionsWindow.Server = _Client.Server;
		optionsWindow.Port = _Client.Port;
		if (((Window)optionsWindow).ShowDialog().GetValueOrDefault())
		{
			_Client.Server = optionsWindow.Server;
			_Client.Port = optionsWindow.Port;
			ServerLbl.Text = _Client.Server;
			try
			{
				File.WriteAllText(_ConfigPath, "SERVER=" + _Client.Server + "\r\nPORT=" + _Client.Port);
			}
			catch (Exception ex)
			{
				ProjectData.SetProjectError(ex);
				Exception ex2 = ex;
				MessageBox.Show("Error saving options to file " + _ConfigPath + " : " + ex2.Message, "Error", (MessageBoxButton)0, (MessageBoxImage)48);
				ProjectData.ClearProjectError();
			}
		}
	}

	private void Window_Loaded(object sender, RoutedEventArgs e)
	{
		//IL_00ca: Unknown result type (might be due to invalid IL or missing references)
		((UIElement)UsernameBox).Focus();
		_LockoutTimer.Elapsed += LockoutTimer_Elapsed;
		try
		{
			if (!File.Exists(_ConfigPath))
			{
				return;
			}
			string[] array = File.ReadAllLines(_ConfigPath);
			foreach (string text in array)
			{
				if (text.StartsWith("SERVER="))
				{
					_Client.Server = text.Substring(7);
					ServerLbl.Text = _Client.Server;
				}
				else if (text.StartsWith("PORT="))
				{
					_Client.Port = Conversions.ToInteger(text.Substring(5));
				}
			}
		}
		catch (Exception ex)
		{
			ProjectData.SetProjectError(ex);
			Exception ex2 = ex;
			MessageBox.Show("Error loading data from config file: " + ex2.Message, "Error", (MessageBoxButton)0, (MessageBoxImage)48);
			ProjectData.ClearProjectError();
		}
	}

	private void SignInBtn_Click(object sender, RoutedEventArgs e)
	{
		//IL_001f: Unknown result type (might be due to invalid IL or missing references)
		//IL_0045: Unknown result type (might be due to invalid IL or missing references)
		//IL_0062: Unknown result type (might be due to invalid IL or missing references)
		if (string.IsNullOrEmpty(_Client.Server))
		{
			MessageBox.Show("Please specify the name or IP address of the Scramble Corp server you wish to connect to", "No Server Specified", (MessageBoxButton)0, (MessageBoxImage)64);
		}
		else if (string.IsNullOrWhiteSpace(UsernameBox.Text))
		{
			MessageBox.Show("Please enter a username", "Invalid Credentials", (MessageBoxButton)0, (MessageBoxImage)64);
		}
		else if (_AttempCount > 5)
		{
			MessageBox.Show("You have attempted to sign in with invalid credentials too many times. Please wait 10 seconds and then try again", "Please Wait", (MessageBoxButton)0, (MessageBoxImage)48);
			if (!_LockoutTimer.Enabled)
			{
				_LockoutTimer.Start();
			}
		}
		else
		{
			((UIElement)MainGrid).IsEnabled = false;
			((UIElement)ProgressPanel).Visibility = (Visibility)0;
			NetworkCredential parameter = new NetworkCredential(UsernameBox.Text, PassBox.Password);
			Thread thread = new Thread(Logon);
			thread.IsBackground = true;
			thread.Start(parameter);
		}
	}

	private void Logon(object CredsObject)
	{
		bool logonSuccess = false;
		string errorMessage = string.Empty;
		NetworkCredential networkCredential = (NetworkCredential)CredsObject;
		try
		{
			logonSuccess = _Client.Logon(networkCredential.UserName, networkCredential.Password);
		}
		catch (Exception ex)
		{
			ProjectData.SetProjectError(ex);
			Exception ex2 = ex;
			errorMessage = ex2.Message;
			ProjectData.ClearProjectError();
		}
		finally
		{
			LoginComplete(logonSuccess, errorMessage);
		}
	}

	private void LoginComplete(bool LogonSuccess, string ErrorMessage)
	{
		//IL_00a0: Unknown result type (might be due to invalid IL or missing references)
		//IL_0086: Unknown result type (might be due to invalid IL or missing references)
		checked
		{
			if (((DispatcherObject)this).Dispatcher.CheckAccess())
			{
				if (((FrameworkElement)this).IsLoaded)
				{
					((UIElement)MainGrid).IsEnabled = true;
					((UIElement)ProgressPanel).Visibility = (Visibility)2;
					if (LogonSuccess)
					{
						((Window)new MainWindow
						{
							Client = _Client,
							Username = UsernameBox.Text
						}).Show();
						((Window)this).Close();
					}
					else if (string.IsNullOrWhiteSpace(ErrorMessage))
					{
						_AttempCount++;
						MessageBox.Show("Invalid username or password entered", "Invalid Credentials", (MessageBoxButton)0, (MessageBoxImage)48);
					}
					else
					{
						MessageBox.Show("Unable to sign you in due to the following error: " + ErrorMessage, "Error Encountered", (MessageBoxButton)0, (MessageBoxImage)48);
					}
				}
			}
			else
			{
				((DispatcherObject)this).Dispatcher.Invoke((Delegate)new Action<bool, string>(LoginComplete), new object[2] { LogonSuccess, ErrorMessage });
			}
		}
	}

	private void LockoutTimer_Elapsed(object sender, ElapsedEventArgs e)
	{
		_AttempCount = 0;
		_LockoutTimer.Stop();
	}

	[DebuggerNonUserCode]
	[GeneratedCode("PresentationBuildTasks", "4.0.0.0")]
	public void InitializeComponent()
	{
		if (!_contentLoaded)
		{
			_contentLoaded = true;
			Uri uri = new Uri("/ScrambleClient;component/windows/loginwindow.xaml", UriKind.Relative);
			Application.LoadComponent((object)this, uri);
		}
	}

	[DebuggerNonUserCode]
	[GeneratedCode("PresentationBuildTasks", "4.0.0.0")]
	[EditorBrowsable(EditorBrowsableState.Never)]
	public void System_Windows_Markup_IComponentConnector_Connect(int connectionId, object target)
	{
		//IL_0006: Unknown result type (might be due to invalid IL or missing references)
		//IL_0010: Expected O, but got Unknown
		//IL_0017: Unknown result type (might be due to invalid IL or missing references)
		//IL_0021: Expected O, but got Unknown
		//IL_0028: Unknown result type (might be due to invalid IL or missing references)
		//IL_0032: Expected O, but got Unknown
		//IL_003f: Unknown result type (might be due to invalid IL or missing references)
		//IL_0049: Expected O, but got Unknown
		//IL_0050: Unknown result type (might be due to invalid IL or missing references)
		//IL_005a: Expected O, but got Unknown
		//IL_0061: Unknown result type (might be due to invalid IL or missing references)
		//IL_006b: Expected O, but got Unknown
		//IL_0072: Unknown result type (might be due to invalid IL or missing references)
		//IL_007c: Expected O, but got Unknown
		//IL_0083: Unknown result type (might be due to invalid IL or missing references)
		//IL_008d: Expected O, but got Unknown
		//IL_0094: Unknown result type (might be due to invalid IL or missing references)
		//IL_009e: Expected O, but got Unknown
		switch (connectionId)
		{
		case 1:
			MainGrid = (Grid)target;
			break;
		case 2:
			ServerLbl = (TextBlock)target;
			break;
		case 3:
			EditServerLink = (Hyperlink)target;
			EditServerLink.Click += new RoutedEventHandler(EditServerLink_Click);
			break;
		case 4:
			UsernameBox = (TextBox)target;
			break;
		case 5:
			PassBox = (PasswordBox)target;
			break;
		case 6:
			SignInBtn = (Button)target;
			break;
		case 7:
			ProgressPanel = (StackPanel)target;
			break;
		case 8:
			Spacer = (Border)target;
			break;
		default:
			_contentLoaded = true;
			break;
		}
	}
}
