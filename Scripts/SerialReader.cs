using Godot;
using System;
using System.IO.Ports;
using System.Threading;
using System.Text.RegularExpressions;

public partial class SerialReader : Node
{
	[Export] public string PortName = "COM5";
	[Export] public int BaudRate = 9600;

	private SerialPort _serialPort;
	private Thread _readThread;
	private bool _isRunning = false;

	// Variável estática acessível por qualquer outro script no jogo
	public static int CurrentBpm { get; private set; } = 80;

	public override void _Ready()
	{
		StartSerial();
	}

	private void StartSerial()
	{
		try
		{
			_serialPort = new SerialPort(PortName, BaudRate)
			{
				ReadTimeout = 1000,
				NewLine = "\n"
			};
			
			_serialPort.Open();
			_isRunning = true;

			// Cria uma thread separada para não congelar a interface/jogo
			_readThread = new Thread(ReadSerialLoop)
			{
				IsBackground = true
			};
			_readThread.Start();

			GD.Print($"[SerialReader] Conectado à porta {PortName} com sucesso!");
		}
		catch (Exception ex)
		{
			GD.PrintErr($"[SerialReader] Erro ao abrir a porta {PortName}: {ex.Message}");
		}
	}

	private void ReadSerialLoop()
{
	while (_isRunning && _serialPort != null && _serialPort.IsOpen)
	{
		try
		{
			string line = _serialPort.ReadLine().Trim();
			
			if (!string.IsNullOrEmpty(line))
			{
				// Extrai apenas os números contidos na mensagem recebida
				Match match = Regex.Match(line, @"\d+");
				
				if (match.Success && int.TryParse(match.Value, out int bpm))
				{
					CurrentBpm = bpm;
					UpdateGdscriptGlobal(bpm);
					GD.Print($"[SerialReader] BPM extraído com sucesso: {bpm}");
				}
			}
		}
		catch (TimeoutException)
		{
			// Timeout normal
		}
		catch (Exception ex)
		{
			GD.PrintErr($"[SerialReader] Erro: {ex.Message}");
		}
	}
}

	private void UpdateGdscriptGlobal(int bpm)
	{
		// Se você tiver um Autoload em GDScript chamado 'Global', atualiza-o diretamente
		var globalNode = GetNodeOrNull("/root/Global");
		if (globalNode != null)
		{
			globalNode.Set("batimentos_bpm", bpm);
		}
	}

	// Método seguro para fechar a porta ao sair do jogo
	public override void _ExitTree()
	{
		_isRunning = false;
		if (_serialPort != null && _serialPort.IsOpen)
		{
			try
			{
				_serialPort.Close();
				_serialPort.Dispose();
				GD.Print("[SerialReader] Porta Serial fechada com sucesso.");
			}
			catch (Exception ex)
			{
				GD.PrintErr($"[SerialReader] Erro ao fechar a porta serial: {ex.Message}");
			}
		}
	}

	// Método auxiliar público caso precise ler via GDScript
	public int GetBpm()
	{
		return CurrentBpm;
	}
}
