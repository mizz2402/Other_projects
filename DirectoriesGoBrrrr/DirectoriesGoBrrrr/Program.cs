using System;
using System.IO;

namespace DirectoriesGoBrrrr {
	class Program {
		static void Main(string[] args) {
			ReadData(@"G:\Projekty robocze VS\folde\input.csv", out string[,] input);
			ReadData(@"G:\Projekty robocze VS\folde\rIndexes.txt", out string[,] rIndexes);
			CreateDirectories(@"G:\Projekty robocze VS\folde\output\", input, rIndexes);
			

			/*
			Excel excel = new Excel(@"G:\Projekty robocze VS\folde\output\", "napowietrzny.xlsx");
			excel.CreateFiles();
			excel.UpdateFileName("wielorodzinny.xlsx");
			excel.CreateFiles();
			excel.UpdateFileName("ziemny.xlsx");
			excel.CreateFiles();
			*/

			Console.ReadKey();
		}

		static void ReadData(string path, out string[,] output) {
			FileStream fs = new FileStream(path, FileMode.Open, FileAccess.Read);
			StreamReader sr = new StreamReader(fs);

			string content = sr.ReadToEnd();        //might change to var
			var lines = content.Split('\n');        //new char[] { '\n' }
			int count = lines.Length;
			if(lines[0].Split(',').Length > 2)		// CSV type:	,	;	x1
				output = new string[count, 3];
			else
				output = new string[count, 2];
			int i = 0;
			foreach(string line in lines) {
				string[] values = line.Split(',');	//CSV type:		,	;	x2
				output[i, 0] = values[(output.GetLength(1) <= 2 ? 0 : 0)];			//OF
				output[i, 1] = values[(output.GetLength(1) <= 2 ? 1 : 1)];			//REGION POPC3
				if (output.GetLength(1) == 3)
					output[i, 2] = values[4];		//PE K
				i++;
			}
			sr.Close();
		}

		static void CreateDirectories(string mainPath, string[,] input, string[,] rIndexes) {
			string path;
			for (int i = 0; i < input.GetLength(0); i++) {
				string dirName = $"{GetIndex(input[i, 1], rIndexes).Trim()}_{input[i, 0].Trim()}";
				Console.WriteLine(dirName);
				path = mainPath + dirName;
				path += @"/2021-06-15";		//DATA AUDYTU
				if(!(Directory.Exists(path))) {
					try {
						Directory.CreateDirectory(path);
						for (int j = 1; j <= int.Parse(input[i, 2]); j++) {
							string pathEnd = $@"\{dirName}_MS00000{j,2:D2}";
							//Directory.CreateDirectory(path + $@"\{dirName}_MS00000{j, 2:D2}");
							Directory.CreateDirectory(path + pathEnd);

							//EXCEL
							File.Copy(@"G:\Projekty robocze VS\folde\Excel\napowietrzny.xlsx", path + pathEnd + pathEnd + "_napowietrzny.xlsx");
							File.Copy(@"G:\Projekty robocze VS\folde\Excel\wielorodzinny.xlsx", path + pathEnd + pathEnd + "_wielorodzinny.xlsx");
							File.Copy(@"G:\Projekty robocze VS\folde\Excel\ziemny.xlsx", path + pathEnd + pathEnd + "_ziemny.xlsx");

						}
					} catch (Exception e) {
						Console.WriteLine(e.Message);
					}
					
				} else
					Console.WriteLine("Folder już istnieje: " + dirName);
			}
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
