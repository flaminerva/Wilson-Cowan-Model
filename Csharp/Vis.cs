namespace ConsoleApp1;

public static class Vis
{
   public static void Plot(List<List<double[]>> res)
   {
      ScottPlot.Plot myPlot = new ScottPlot.Plot();
      myPlot.Axes.SetLimits(-3, 3, -3, 3);
      myPlot.Add.HorizontalLine(0);
      myPlot.Add.VerticalLine(0);

      foreach (List<double[]> trj in res)
      {
         double[] x = trj.Select(p => p[0]).ToArray();
         double[] y = trj.Select(p => p[1]).ToArray();
         var scatter = myPlot.Add.Scatter(x, y);
         scatter.LineWidth = (float)1;
         scatter.MarkerSize = 0;
      }
      
      myPlot.SavePng("/Users/koukaetsu/RiderProjects/ConsoleApp1/ConsoleApp1/output/quickstart.png", 400, 300);
   }

}
   