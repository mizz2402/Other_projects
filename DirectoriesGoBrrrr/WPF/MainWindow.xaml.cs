using System;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WPF {
	/// <summary>
	/// Interaction logic for MainWindow.xaml
	/// </summary>
	public partial class MainWindow : Window {
		List<Audyt> audyty = new List<Audyt>();
		public string[,] rIndexes;
		public MainWindow() {
			InitializeComponent();
			//	load region indexes
			dateText.Text = DateTime.Today.ToString("yyyy-MM-dd");
			ReadData(@"rIndexes.csv", out rIndexes);
		}

		private void pasteBtn_Click(object sender, RoutedEventArgs e) {
			audyty = Audyty();
			ListCollectionView cv = new ListCollectionView(audyty);
			grid.ItemsSource = cv;
			infoTextDisplay(audyty);
		}

		private void createFilesBtn_Click(object sender, RoutedEventArgs e) {
			string path = @"output\";
			foreach (Audyt a in audyty) {
				string dirName = $"{GetIndex(a.Region_POPC3, rIndexes).Trim()}_{a.OF.Trim()}";
				Directory.CreateDirectory(path + dirName);
				for (int i = 1; i <= a.PE_K; i++) {
					string finalPath = $@"{path}{dirName}\{dateText.Text}\{dirName}_MS00000{i,2:D2}";
					Directory.CreateDirectory(finalPath);

					File.Copy(@"Excel\napowietrzny.xlsx", $@"{finalPath}\{dirName}_MS00000{i,2:D2}" + "_napowietrzny.xlsx");
					File.Copy(@"Excel\wielorodzinny.xlsx", $@"{finalPath}\{dirName}_MS00000{i,2:D2}" + "_wielorodzinny.xlsx");
					File.Copy(@"Excel\ziemny.xlsx", $@"{finalPath}\{dirName}_MS00000{i,2:D2}" + "_ziemny.xlsx");
				}

			}
			MessageBox.Show("Utworzono!");
		}

		List<Audyt> Audyty() {
			string input = Clipboard.GetText();
			//	MAIL
			input = input.Replace(Environment.NewLine + "\t" + Environment.NewLine + Environment.NewLine, ";");
			input = input.Replace(Environment.NewLine + Environment.NewLine, Environment.NewLine);
			input = input.Replace("__", Environment.NewLine);

			// EXCEL
			input = input.Replace('\t', ';');

			string[] records = input.Split(Environment.NewLine);
			//textBox.Text = records[records.Length - 1];
			List<Audyt> audyty = new List<Audyt>();

			List<string> nazwyKolumn = records[0].Split(';').ToList();

			for (int i = 1; i < records.Length; i++) {
				string[] values = records[i].Split(';');
				if (values[0] == String.Empty)
					continue;
				if (dateFilterText.Text != String.Empty)
					if (dateFilterText.Text != values[nazwyKolumn.FindIndex(x => x == "Data zlecenia")])
						continue;
				try {
					Audyt a = new Audyt {
						OF = values[nazwyKolumn.FindIndex(x => x == "OF")],
						Region_POPC3 = values[nazwyKolumn.FindIndex(x => x == "Region POPC3")],
						PE_K = int.Parse(values[nazwyKolumn.FindIndex(x => x == "PE K")]),
					};
					audyty.Add(a);
				} catch { }
			}

			return audyty;
		}

		void infoTextDisplay(List<Audyt> audyty) {
			string output = String.Empty;
			output += "Trasy: " + audyty.Count + Environment.NewLine;
			output += "Punkty: " + audyty.Sum(x => x.PE_K) + Environment.NewLine;
			output += "Excele: " + audyty.Sum(x => x.PE_K) * 3 + Environment.NewLine;
			infoText.Text = output;
		}

		//--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

		void ReadData(string path, out string[,] output) {
			FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);
			StreamReader sr = new StreamReader(fs);

			string content = sr.ReadToEnd();        //might change to var
			var lines = content.Split('\n');        //new char[] { '\n' }
			int count = lines.Length;
			if (lines[0].Split(',').Length > 2)     // CSV type:	,	;	x1
				output = new string[count, 3];
			else
				output = new string[count, 2];
			int i = 0;
			foreach (string line in lines) {
				string[] values = line.Split(',');  //CSV type:		,	;	x2
				output[i, 0] = values[(output.GetLength(1) <= 2 ? 0 : 0)];          //OF
				output[i, 1] = values[(output.GetLength(1) <= 2 ? 1 : 1)];          //REGION POPC3
				if (output.GetLength(1) == 3)
					output[i, 2] = values[4];       //PE K
				i++;
			}
			sr.Close();
		}

		static string GetIndex(string region, string[,] rIndexes) {
			region.Trim();
			int i;
			for (i = 0; i < rIndexes.GetLength(0); i++)
				if (rIndexes[i, 0].Trim() == region)
					return rIndexes[i, 1];

			Console.WriteLine("Nie znaleziono: " + region);
			return "error";
		}
	}
}
