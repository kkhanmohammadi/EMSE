import java.awt.*;
import java.io.*;
import javax.swing.*;
import weka.core.*;
import weka.gui.visualize.*;

/**
 * Visualizes previously saved ROC curves.
 *
 * @author FracPete
 */
public class VisualizeMultipleROC {
  
  /**
   * takes arbitraty number of arguments: 
   * previously saved ROC curve data (ARFF file)
   */
	// arguments of the program D:\Ava\Empirical2018\TrojansResult\ROC-Adware.arff D:\Ava\Empirical2018\TrojansResult\ROC-TrojanAdwareAdded.arff D:\Ava\Empirical2018\TrojansResult\ROC-tracesTrojanAdwareAddedDeleted.arff
  public static void main(String[] args) throws Exception {
    boolean first = true;
    ThresholdVisualizePanel vmc = new ThresholdVisualizePanel();
    for (int i = 0; i < args.length; i++) {
      Instances result = new Instances(
                            new BufferedReader(
                              new FileReader(args[i])));
      result.deleteAttributeAt(0);
      result.setClassIndex(result.numAttributes() - 1);
      // method visualize
      System.out.println("last instance:"+result.lastInstance().toString());
      System.out.println("first instance:"+result.firstInstance().toString());

      PlotData2D tempd = new PlotData2D(result);
      tempd.setPlotName(result.relationName()+i);
      switch(i){
      case 0:    
    	  tempd.setPlotName("Experiment 3"); break;
      case 1:
    	  tempd.setPlotName("Experiment 2 (Genome and GooglePlayStore)"); break;
      case 2:
    	  tempd.setPlotName(""); break;
			
      }
      tempd.addInstanceNumberAttribute();
      // specify which points are connected
      boolean[] cp = new boolean[result.numInstances()];
      for (int n = 1; n < cp.length; n++) 
        cp[n] = true;
      tempd.setConnectPoints(cp);
      // add plot
      if (first){
        vmc.setMasterPlot(tempd);
        System.out.println("1");
      }
      else{
        vmc.addPlot(tempd);
        System.out.println("2");
      }
      first = false;
    }
    // method visualizeClassifierErrors
    final javax.swing.JFrame jf = 
      new javax.swing.JFrame("Weka Classifier ROC");
    jf.setSize(500,400);
    jf.getContentPane().setLayout(new BorderLayout());

    jf.getContentPane().add(vmc, BorderLayout.CENTER);
    jf.addWindowListener(new java.awt.event.WindowAdapter() {
     public void windowClosing(java.awt.event.WindowEvent e) {
        jf.dispose();
      }
    });

    jf.setVisible(true);
  }
}
