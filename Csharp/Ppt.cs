namespace ConsoleApp1;

public static class Ppt
{
    public static List<Double[]> Trj(OdeSys f, double[] ins, int step = 100, double dt=0.01)
    {
        List<Double[]> res = new List<double[]>();
        double[] now = ins;
        for(int i=0; i<step; i++)
        {
            if (Math.Abs(now[0]) > 10 || Math.Abs(now[1]) > 10)
                break;
            double[] xn = Solver.Rk4Step(f, now, dt);
            res.Add(xn);
            now = xn;
        }
        return res;
    }

    public static List<List<Double[]>> Trjs(OdeSys f, int num, int step1 = 100, double dt1=0.01)
    {
        Random rng = new Random(42);
        List<List<Double[]>> res1= new List<List<double[]>>();
        for (int i = 0; i < num; i++)
        {
            double x = rng.NextDouble() * 6 - 3;
            double y = rng.NextDouble() * 6 - 3;
            double[] ins1 = [x, y];
            res1.Add(Trj(f, ins1, step1, dt1));
            
            
        }
        return res1;
    }
}