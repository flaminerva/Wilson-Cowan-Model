// See https://aka.ms/new-console-template for more information

using ConsoleApp1;

public class Program
{
    public static void Main(string[] args)
    {
        OdeSys hw = s => [s[1] * s[1] - s[0], s[0] * s[1] + s[0]]; // input:[x(t),y(t)] => output:[dx/dt,dy/dt]
        double[] ins = [0.1, 0.1];
        int num = 10;
        var data = Ppt.Trjs(hw, num=100, 1000, 0.01);
        Vis.Plot(data);
}
}

