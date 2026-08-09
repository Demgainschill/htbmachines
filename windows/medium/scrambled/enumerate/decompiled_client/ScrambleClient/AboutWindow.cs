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
using ScrambleClient.My;

namespace ScrambleClient;

[DesignerGenerated]
public class AboutWindow : Window, IComponentConnector
{
	[CompilerGenerated]
	[AccessedThroughProperty("CloseBtn")]
	private Button _CloseBtn;

	private bool _contentLoaded;

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

	[field: AccessedThroughProperty("VersionLbl")]
	internal virtual TextBlock VersionLbl
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
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

	public AboutWindow()
	{
		//IL_000e: Unknown result type (might be due to invalid IL or missing references)
		//IL_0018: Expected O, but got Unknown
		((FrameworkElement)this).Loaded += new RoutedEventHandler(Window_Loaded);
		InitializeComponent();
	}

	private void CloseBtn_Click(object sender, RoutedEventArgs e)
	{
		((Window)this).Close();
	}

	private void Window_Loaded(object sender, RoutedEventArgs e)
	{
		VersionLbl.Text = MyWpfExtension.Application.Info.Version.ToString();
	}

	[DebuggerNonUserCode]
	[GeneratedCode("PresentationBuildTasks", "4.0.0.0")]
	public void InitializeComponent()
	{
		if (!_contentLoaded)
		{
			_contentLoaded = true;
			Uri uri = new Uri("/ScrambleClient;component/windows/aboutwindow.xaml", UriKind.Relative);
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
		switch (connectionId)
		{
		case 1:
			MainGrid = (Grid)target;
			break;
		case 2:
			TitleLbl = (TextBlock)target;
			break;
		case 3:
			VersionLbl = (TextBlock)target;
			break;
		case 4:
			CloseBtn = (Button)target;
			break;
		default:
			_contentLoaded = true;
			break;
		}
	}
}
