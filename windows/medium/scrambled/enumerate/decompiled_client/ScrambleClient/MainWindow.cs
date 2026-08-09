using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.ComponentModel;
using System.Diagnostics;
using System.Runtime.CompilerServices;
using System.Threading;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Controls.Primitives;
using System.Windows.Markup;
using System.Windows.Threading;
using Microsoft.VisualBasic.CompilerServices;
using ScrambleLib;

namespace ScrambleClient;

[DesignerGenerated]
public class MainWindow : Window, IComponentConnector
{
	private ObservableCollection<SalesOrder> _Orders;

	private List<string> _Reps;

	[CompilerGenerated]
	[AccessedThroughProperty("UploadOrderBtn")]
	private Button _UploadOrderBtn;

	private bool _contentLoaded;

	public ScrambleNetClient Client { get; set; }

	public string Username { get; set; }

	[field: AccessedThroughProperty("ExitMenuItem")]
	internal virtual MenuItem ExitMenuItem
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("EnableLoggingMenuItem")]
	internal virtual MenuItem EnableLoggingMenuItem
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("AboutMeniItem")]
	internal virtual MenuItem AboutMeniItem
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("MainGrid")]
	internal virtual Grid MainGrid
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("UsernameLbl")]
	internal virtual TextBlock UsernameLbl
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("MotdLbl")]
	internal virtual TextBlock MotdLbl
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("MainTabCtrl")]
	internal virtual TabControl MainTabCtrl
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("FilesListBox")]
	internal virtual ListView FilesListBox
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	internal virtual Button UploadOrderBtn
	{
		[CompilerGenerated]
		get
		{
			return _UploadOrderBtn;
		}
		[MethodImpl(MethodImplOptions.Synchronized)]
		[CompilerGenerated]
		set
		{
			//IL_0007: Unknown result type (might be due to invalid IL or missing references)
			//IL_000d: Expected O, but got Unknown
			RoutedEventHandler val = new RoutedEventHandler(UploadOrderBtn_Click);
			Button uploadOrderBtn = _UploadOrderBtn;
			if (uploadOrderBtn != null)
			{
				((ButtonBase)uploadOrderBtn).Click -= val;
			}
			_UploadOrderBtn = value;
			uploadOrderBtn = _UploadOrderBtn;
			if (uploadOrderBtn != null)
			{
				((ButtonBase)uploadOrderBtn).Click += val;
			}
		}
	}

	[field: AccessedThroughProperty("OrderRefBox")]
	internal virtual TextBox OrderRefBox
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("SalesRepCombo")]
	internal virtual ComboBox SalesRepCombo
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("DueDatePicker")]
	internal virtual DatePicker DueDatePicker
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("QuoteRefBox")]
	internal virtual TextBox QuoteRefBox
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("CostBox")]
	internal virtual TextBox CostBox
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("ProgressLbl")]
	internal virtual TextBlock ProgressLbl
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	[field: AccessedThroughProperty("ProgBar")]
	internal virtual ProgressBar ProgBar
	{
		get; [MethodImpl(MethodImplOptions.Synchronized)]
		set;
	}

	public MainWindow()
	{
		//IL_000e: Unknown result type (might be due to invalid IL or missing references)
		//IL_0018: Expected O, but got Unknown
		((FrameworkElement)this).Loaded += new RoutedEventHandler(Window_Loaded);
		Username = string.Empty;
		_Orders = new ObservableCollection<SalesOrder>();
		_Reps = new List<string> { "J Hall", "S Jenkins", "R Smith", "E Hooker", "R Goodhand" };
		InitializeComponent();
	}

	private void Window_Loaded(object sender, RoutedEventArgs e)
	{
		UsernameLbl.Text = "Welcome back " + Username;
		((ItemsControl)FilesListBox).ItemsSource = _Orders;
		((ItemsControl)SalesRepCombo).ItemsSource = _Reps;
		((Selector)SalesRepCombo).SelectedIndex = 0;
		EnableLoggingMenuItem.IsChecked = Log.LoggingEnabled;
		LockUI("Retrieving orders from server...");
		Thread thread = new Thread(GetOrdersFromServer);
		thread.IsBackground = true;
		thread.Start();
	}

	private void GetOrdersFromServer()
	{
		List<SalesOrder> newOrders = null;
		string errorMessage = string.Empty;
		try
		{
			Log.Write("Getting order list from server");
			newOrders = Client.GetOrders();
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
			GetOrdersFinished(newOrders, errorMessage);
		}
	}

	private void GetOrdersFinished(List<SalesOrder> NewOrders, string ErrorMessage)
	{
		//IL_00b8: Unknown result type (might be due to invalid IL or missing references)
		if (((DispatcherObject)this).Dispatcher.CheckAccess())
		{
			if (!((FrameworkElement)this).IsLoaded)
			{
				return;
			}
			UnlockUI();
			if (string.IsNullOrEmpty(ErrorMessage))
			{
				_Orders.Clear();
				foreach (SalesOrder NewOrder in NewOrders)
				{
					_Orders.Add(NewOrder);
				}
				ProgressLbl.Text = Conversions.ToString(_Orders.Count) + ((_Orders.Count == 1) ? " order found" : " orders found");
			}
			else
			{
				MessageBox.Show("Unable to load orders due to the following error: \r\n" + ErrorMessage, "Error", (MessageBoxButton)0, (MessageBoxImage)48);
				ProgressLbl.Text = "Error encountered";
			}
		}
		else
		{
			((DispatcherObject)this).Dispatcher.Invoke((Delegate)new Action<List<SalesOrder>, string>(GetOrdersFinished), new object[2] { NewOrders, ErrorMessage });
		}
	}

	private void LockUI(string ProgressMessage)
	{
		ProgressLbl.Text = ProgressMessage;
		((UIElement)ProgBar).Visibility = (Visibility)0;
		((UIElement)MainGrid).IsEnabled = false;
		((UIElement)MainTabCtrl).IsEnabled = false;
	}

	private void UnlockUI()
	{
		((UIElement)ProgBar).Visibility = (Visibility)2;
		((UIElement)MainGrid).IsEnabled = true;
		((UIElement)MainTabCtrl).IsEnabled = true;
	}

	private void ExitMenuItem_Click(object sender, RoutedEventArgs e)
	{
		((Window)this).Close();
	}

	private void AboutMeniItem_Click(object sender, RoutedEventArgs e)
	{
		((Window)new AboutWindow()).ShowDialog();
	}

	private void UploadOrderBtn_Click(object sender, RoutedEventArgs e)
	{
		//IL_0124: Unknown result type (might be due to invalid IL or missing references)
		//IL_001f: Unknown result type (might be due to invalid IL or missing references)
		//IL_0048: Unknown result type (might be due to invalid IL or missing references)
		if (string.IsNullOrWhiteSpace(OrderRefBox.Text))
		{
			MessageBox.Show("Please enter an order reference number", "No Order Reference", (MessageBoxButton)0, (MessageBoxImage)64);
			return;
		}
		if (!DueDatePicker.SelectedDate.HasValue)
		{
			MessageBox.Show("Please enter a due date", "No Due Date", (MessageBoxButton)0, (MessageBoxImage)64);
			return;
		}
		try
		{
			SalesOrder salesOrder = new SalesOrder();
			salesOrder.ReferenceNumber = OrderRefBox.Text;
			salesOrder.SalesRep = Conversions.ToString(((Selector)SalesRepCombo).SelectedItem);
			salesOrder.QuoteReference = QuoteRefBox.Text;
			salesOrder.DueDate = DueDatePicker.SelectedDate.Value;
			salesOrder.TotalCost = (string.IsNullOrWhiteSpace(CostBox.Text) ? 0.0 : Conversions.ToDouble(CostBox.Text));
			Thread obj = new Thread(UploadNewOrder)
			{
				IsBackground = true
			};
			LockUI("Sending order to server...");
			obj.Start(salesOrder);
		}
		catch (Exception ex)
		{
			ProjectData.SetProjectError(ex);
			Exception ex2 = ex;
			MessageBox.Show("Error parsing input: " + ex2.Message, "Error", (MessageBoxButton)0, (MessageBoxImage)16);
			ProjectData.ClearProjectError();
		}
	}

	private void UploadNewOrder(object NewOrder)
	{
		string errorMessage = string.Empty;
		try
		{
			Client.UploadOrder((SalesOrder)NewOrder);
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
			UploadNewOrderFinished(errorMessage);
		}
	}

	private void UploadNewOrderFinished(string ErrorMessage)
	{
		//IL_0095: Unknown result type (might be due to invalid IL or missing references)
		//IL_006b: Unknown result type (might be due to invalid IL or missing references)
		if (((DispatcherObject)this).Dispatcher.CheckAccess())
		{
			UnlockUI();
			if (string.IsNullOrEmpty(ErrorMessage))
			{
				ProgressLbl.Text = "Order uploaded successfully";
				OrderRefBox.Text = string.Empty;
				QuoteRefBox.Text = string.Empty;
				CostBox.Text = string.Empty;
				MessageBox.Show("Order sent to server successfully", "Upload Complete", (MessageBoxButton)0, (MessageBoxImage)64);
			}
			else
			{
				ProgressLbl.Text = "Order upload failed";
				MessageBox.Show("Error sending order to server: " + ErrorMessage, "Order Upload Failed", (MessageBoxButton)0, (MessageBoxImage)16);
			}
		}
		else
		{
			((DispatcherObject)this).Dispatcher.Invoke((Delegate)new Action<string>(UploadNewOrderFinished), new object[1] { ErrorMessage });
		}
	}

	private void EnableLoggingMenuItem_Click(object sender, RoutedEventArgs e)
	{
		//IL_0057: Unknown result type (might be due to invalid IL or missing references)
		//IL_0033: Unknown result type (might be due to invalid IL or missing references)
		EnableLoggingMenuItem.IsChecked = !EnableLoggingMenuItem.IsChecked;
		if (Log.LoggingEnabled)
		{
			Log.LoggingEnabled = false;
			MessageBox.Show("Debug logging disabled", "Logging Disabled", (MessageBoxButton)0, (MessageBoxImage)64);
		}
		else
		{
			Log.LoggingEnabled = true;
			MessageBox.Show("Logging enabled and being saved to file " + Log.LogFilePath, "Logging Enabled", (MessageBoxButton)0, (MessageBoxImage)64);
		}
	}

	[DebuggerNonUserCode]
	[GeneratedCode("PresentationBuildTasks", "4.0.0.0")]
	public void InitializeComponent()
	{
		if (!_contentLoaded)
		{
			_contentLoaded = true;
			Uri uri = new Uri("/ScrambleClient;component/windows/mainwindow.xaml", UriKind.Relative);
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
		//IL_001d: Unknown result type (might be due to invalid IL or missing references)
		//IL_0027: Expected O, but got Unknown
		//IL_002e: Unknown result type (might be due to invalid IL or missing references)
		//IL_0038: Expected O, but got Unknown
		//IL_0045: Unknown result type (might be due to invalid IL or missing references)
		//IL_004f: Expected O, but got Unknown
		//IL_0056: Unknown result type (might be due to invalid IL or missing references)
		//IL_0060: Expected O, but got Unknown
		//IL_006d: Unknown result type (might be due to invalid IL or missing references)
		//IL_0077: Expected O, but got Unknown
		//IL_007e: Unknown result type (might be due to invalid IL or missing references)
		//IL_0088: Expected O, but got Unknown
		//IL_008f: Unknown result type (might be due to invalid IL or missing references)
		//IL_0099: Expected O, but got Unknown
		//IL_00a0: Unknown result type (might be due to invalid IL or missing references)
		//IL_00aa: Expected O, but got Unknown
		//IL_00b1: Unknown result type (might be due to invalid IL or missing references)
		//IL_00bb: Expected O, but got Unknown
		//IL_00c2: Unknown result type (might be due to invalid IL or missing references)
		//IL_00cc: Expected O, but got Unknown
		//IL_00d4: Unknown result type (might be due to invalid IL or missing references)
		//IL_00de: Expected O, but got Unknown
		//IL_00e6: Unknown result type (might be due to invalid IL or missing references)
		//IL_00f0: Expected O, but got Unknown
		//IL_00f8: Unknown result type (might be due to invalid IL or missing references)
		//IL_0102: Expected O, but got Unknown
		//IL_010a: Unknown result type (might be due to invalid IL or missing references)
		//IL_0114: Expected O, but got Unknown
		//IL_011c: Unknown result type (might be due to invalid IL or missing references)
		//IL_0126: Expected O, but got Unknown
		//IL_012e: Unknown result type (might be due to invalid IL or missing references)
		//IL_0138: Expected O, but got Unknown
		//IL_0140: Unknown result type (might be due to invalid IL or missing references)
		//IL_014a: Expected O, but got Unknown
		//IL_0152: Unknown result type (might be due to invalid IL or missing references)
		//IL_015c: Expected O, but got Unknown
		switch (connectionId)
		{
		case 1:
			ExitMenuItem = (MenuItem)target;
			ExitMenuItem.Click += new RoutedEventHandler(ExitMenuItem_Click);
			break;
		case 2:
			EnableLoggingMenuItem = (MenuItem)target;
			EnableLoggingMenuItem.Click += new RoutedEventHandler(EnableLoggingMenuItem_Click);
			break;
		case 3:
			AboutMeniItem = (MenuItem)target;
			AboutMeniItem.Click += new RoutedEventHandler(AboutMeniItem_Click);
			break;
		case 4:
			MainGrid = (Grid)target;
			break;
		case 5:
			UsernameLbl = (TextBlock)target;
			break;
		case 6:
			MotdLbl = (TextBlock)target;
			break;
		case 7:
			MainTabCtrl = (TabControl)target;
			break;
		case 8:
			FilesListBox = (ListView)target;
			break;
		case 9:
			UploadOrderBtn = (Button)target;
			break;
		case 10:
			OrderRefBox = (TextBox)target;
			break;
		case 11:
			SalesRepCombo = (ComboBox)target;
			break;
		case 12:
			DueDatePicker = (DatePicker)target;
			break;
		case 13:
			QuoteRefBox = (TextBox)target;
			break;
		case 14:
			CostBox = (TextBox)target;
			break;
		case 15:
			ProgressLbl = (TextBlock)target;
			break;
		case 16:
			ProgBar = (ProgressBar)target;
			break;
		default:
			_contentLoaded = true;
			break;
		}
	}
}
