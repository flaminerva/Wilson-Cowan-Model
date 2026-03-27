namespace ConsoleApp1;

public static class Solver
{
    // RK4
    public static double[] Rk4Step(OdeSys f, double[] s,double dt = 0.01)
    {
        double[] k1 = f(s).Select(x=>x*dt).ToArray();
        double[] mid = s.Select((x,i)=>x+0.5*k1[i]).ToArray();
        double[] k2 = f(mid).Select(x=>x*dt).ToArray();
        double[] mid1 = s.Select((x,i)=>x+0.5*k2[i]).ToArray();
        double[] k3 = f(mid1).Select(x=>x*dt).ToArray();
        double[] mid2 = s.Select((x,i)=>x+k3[i]).ToArray();
        double[] k4 = f(mid2).Select(x=>x*dt).ToArray();
        double[] sn = s.Select((x,i)=>x+1.0/6*(k1[i]+2*k2[i]+2*k3[i]+k4[i])).ToArray();
        return sn;
        
    }
}