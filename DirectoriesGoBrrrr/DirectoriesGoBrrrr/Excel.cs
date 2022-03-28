using System;
using System.IO;
using System.Collections.Generic;
using System.Text;

namespace DirectoriesGoBrrrr {
	class Excel {
		string mainPath = String.Empty;
		string fileName = String.Empty;
		string templateFile = @"G:\Projekty robocze VS\folde\Excel\";
		public Excel(string _mainPath, string _fileName) {
			mainPath = _mainPath;
			fileName = _fileName;
			templateFile += fileName;
		}

		public void UpdateFileName (string _fileName) {
			templateFile = @"G:\Projekty robocze VS\folde\Excel\";
			fileName = _fileName;
			templateFile += fileName;
		}

		public void CreateFiles() {
			try {
				foreach (string parentPath in Directory.GetDirectories(mainPath))
					foreach (string path in Directory.GetDirectories(parentPath)) {
						//string filePath = path + path.Substring(parentPath.Length) + ".xlsx";
						string name = path.Substring(parentPath.Length);
						string filePath = path + name.Substring(0, name.Length - 9) + $"{fileName}";
						if (!File.Exists(filePath))
							File.Copy(templateFile, filePath);
						else Console.WriteLine("plik istnieje");
					}
			} catch (Exception e) {
				Console.WriteLine(e.Message);
			} finally {
				Console.WriteLine("Program zakończył działanie.");
			}
		}
	}
}
