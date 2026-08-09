using System;
using System.CodeDom.Compiler;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Markup;
using Microsoft.VisualBasic.CompilerServices;
using ScrambleLib;

namespace ScrambleClient;

[DesignerGenerated]
public class OptionsWindow : Window, IComponentConnector
{
	[CompilerGenerated]
	[AccessedThroughProperty("OKBtn")]
	private Button _OKBtn;

	[CompilerGenerated]
	[AccessedThroughProperty("CloseBtn")]
	private Button _CloseBtn;

	private bool _contentLoaded;

	public string Server { get; set; }

	public int Port { get; set; }

	[field: AccessedThroughProperty("MainGrid")]
	internal virtual Grid MainGrid
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("TitleLbl")]
	internal virtual TextBlock TitleLbl
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("ServerBox")]
	internal virtual TextBox ServerBox
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("PortBox")]
	internal virtual TextBox PortBox
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("DebugChk")]
	internal virtual CheckBox DebugChk
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	internal virtual Button OKBtn
	{
		[CompilerGenerated]
		get
		{
			return _OKBtn;
		}
		[MethodImpl(MethodImplOptions.Synchronized)]
		[CompilerGenerated]
		set
		{
			//IL_0007: Unknown result type (might be due to invalid IL or missing references)
			//IL_000d: Expected O, but got Unknown
			RoutedEventHandler val = new RoutedEventHandler(OKBtn_Click);
			Button oKBtn = _OKBtn;
			if (oKBtn != null)
			{
				((ButtonBase)oKBtn).Click -= val;
			}
			_OKBtn = value;
			oKBtn = _OKBtn;
			if (oKBtn != null)
			{
				((ButtonBase)oKBtn).Click += val;
			}
		}
	}

	internal virtual Button CloseBtn
	{
		[CompilerGenerated]
		get
		{
			return _CloseBtn;
		}
		[MethodImpl(MethodImplOptions.Synchronized)]
		[CompilerGenerated]
		set
		{
			//IL_0007: Unknown result type (might be due to invalid IL or missing references)
			//IL_000d: Expected O, but got Unknown
			RoutedEventHandler val = new RoutedEventHandler(CloseBtn_Click);
			Button closeBtn = _CloseBtn;
			if (closeBtn != null)
			{
				((ButtonBase)closeBtn).Click -= val;
			}
			_CloseBtn = value;
			closeBtn = _CloseBtn;
			if (closeBtn != null)
			{
				((ButtonBase)closeBtn).Click += val;
			}
		}
	}

	public OptionsWindow()
	{
		//IL_000e: Unknown result type (might be due to invalid IL or missing references)
		//IL_0018: Expected O, but got Unknown
		((FrameworkElement)this).Loaded += new RoutedEventHandler(Window_Loaded);
		InitializeComponent();
	}

	private void Window_Loaded(object sender, RoutedEventArgs e)
	{
		if (!string.IsNullOrWhiteSpace(Server))
		{
			ServerBox.Text = Server;
		}
		PortBox.Text = Port.ToString();
		((ToggleButton)DebugChk).IsChecked = Log.LoggingEnabled;
		((FrameworkElement)DebugChk).ToolTip = "Enable logging to " + Log.LogFilePath;
		((UIElement)ServerBox).Focus();
	}

	private void CloseBtn_Click(object sender, RoutedEventArgs e)
	{
		((Window)this).DialogResult = false;
	}

	private void OKBtn_Click(object sender, RoutedEventArgs e)
	{
		//IL_001f: Unknown result type (might be due to invalid IL or missing references)
		//IL_0058: Unknown result type (might be due to invalid IL or missing references)
		if (string.IsNullOrWhiteSpace(ServerBox.Text))
		{
			MessageBox.Show("Please specify a server name or IP address", "No Server Specified", (MessageBoxButton)0, (MessageBoxImage)48);
			return;
		}
		if (string.IsNullOrWhiteSpace(PortBox.Text) || Conversions.ToInteger(PortBox.Text) <= 0)
		{
			MessageBox.Show("Please specify a valid TCP port number", "Invalid Port Specified", (MessageBoxButton)0, (MessageBoxImage)48);
			return;
		}
		Server = ServerBox.Text;
		Port = Conversions.ToInteger(PortBox.Text);
		Log.LoggingEnabled = ((ToggleButton)DebugChk).IsChecked.Value;
		((Window)this).DialogResult = true;
	}

	[DebuggerNonUserCode]
	[GeneratedCode("PresentationBuildTasks", "4.0.0.0")]
	public void InitializeComponent()
	{
		if (!_contentLoaded)
		{
			_contentLoaded = true;
			Uri uri = new Uri("/ScrambleClient;component/windows/optionswindow.xaml", UriKind.Relative);
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
		//IL_0039: Unknown result type (might be due to invalid IL or missing references)
		//IL_0043: Expected O, but got Unknown
		//IL_004a: Unknown result type (might be due to invalid IL or missing references)
		//IL_0054: Expected O, but got Unknown
		//IL_005b: Unknown result type (might be due to invalid IL or missing references)
		//IL_0065: Expected O, but got Unknown
		//IL_006c: Unknown result type (might be due to invalid IL or missing references)
		//IL_0076: Expected O, but got Unknown
		switch (connectionId)
		{
		case 1:
			MainGrid = (Grid)target;
			break;
		case 2:
			TitleLbl = (TextBlock)target;
			break;
		case 3:
			ServerBox = (TextBox)target;
			break;
		case 4:
			PortBox = (TextBox)target;
			break;
		case 5:
			DebugChk = (CheckBox)target;
			break;
		case 6:
			OKBtn = (Button)target;
			break;
		case 7:
			CloseBtn = (Button)target;
			break;
		default:
			_contentLoaded = true;
			break;
		}
	}
}
