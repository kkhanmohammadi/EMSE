import java.awt.BorderLayout;
import java.io.BufferedReader;
import java.io.FileReader;
import java.util.LinkedList;
import java.util.List;
import java.util.Random;

import weka.attributeSelection.AttributeSelection;
import weka.attributeSelection.CorrelationAttributeEval;
import weka.attributeSelection.CfsSubsetEval;
import weka.attributeSelection.GreedyStepwise;
import weka.classifiers.Evaluation;
import weka.classifiers.meta.AttributeSelectedClassifier;
import weka.classifiers.meta.FilteredClassifier;
import weka.classifiers.trees.J48;
import weka.core.Instances;
import weka.core.Utils;
import weka.filters.Filter;
import weka.filters.unsupervised.attribute.*;
import weka.gui.visualize.PlotData2D;
import weka.gui.visualize.ThresholdVisualizePanel;
import weka.classifiers.evaluation.ThresholdCurve;
import weka.classifiers.functions.SMO;
import weka.classifiers.trees.RandomForest;
import weka.attributeSelection.*;

public class myWEKA {
	public static void main(String[] args) {
		try{
			System.out.println("Hi");
			
			BufferedReader reader = new BufferedReader(new FileReader("D:/Ava/Classification2018/ZooItemGoogle.arff"));
			Instances data = new Instances(reader);
			reader.close();


			reader = new BufferedReader(new FileReader("D:/Ava/Classification2018/GenomeGoogleItemZooOnlytest.arff"));
			Instances test = new Instances(reader);
			//test.setClassIndex(test.numAttributes() - 1);
			reader.close();

			// delete first attribute
		     //System.out.println("0: "+data.attribute(0).name());

			//data.deleteAttributeAt(0);
			 //System.out.println("0: "+data.attribute(0).name());
			

			//Numeric to Nominal the class attribute(result)
			NumericToNominal convert= new NumericToNominal();
			String[] options= new String[2];
			options[0]="-R";
			options[1]="last";  //range of variables to make numeric
			convert.setOptions(options);
			convert.setInputFormat(data);
			Instances newData=Filter.useFilter(data, convert);
			// setting class attribute

			newData.setClassIndex(newData.numAttributes() - 1);

////////////////////
    //Numeric to Nominal the class attribute(result) for test
		convert= new NumericToNominal();
		options= new String[2];
		options[0]="-R";
		options[1]="last";  //range of variables to make numeric
		convert.setOptions(options);
		convert.setInputFormat(test);
		Instances newTest=Filter.useFilter(test, convert);
		// setting class attribute for test

		newTest.setClassIndex(newTest.numAttributes() - 1);

			
			
		    // int[] indices=infoGain(newData);
			///////////added 30/70
	        newData.randomize(new java.util.Random(0));
	        int trainSize = (int) Math.round(newData.numInstances() * 70/ 100);
	        int testSize = newData.numInstances() - trainSize;
	        Instances train = new Instances(newData, 0, trainSize);
	        Instances test1 = new Instances(newData, trainSize, testSize);
       
	        newTest.addAll(test1);
	        
	        
	       // test1=test;
	        
	        
	        
			int[] indices=Correlation(train);
			 System.out.println("Number of attributes :\n" +data.numAttributes());
			 System.out.println("Number of attributes selected:\n" + indices.length);
			 System.out.println("*selected attribute indices (starting with 0):\n" + Utils.arrayToString(indices));
			 System.out.println("*selected attribute names (starting with 0):\n");
			 for(int i=0;i<indices.length;i++){
				 System.out.println(data.attribute(indices[i]).name());
				 //System.out.println(data.attribute(indices[i]).)
			 }

		     Instances       instNew;
		     Remove          remove;
		   //  System.out.println("0: "+newData.attribute(0));

		     //inst   = train;
		     remove = new Remove();
		     //remove 0 from list indecs
		     String indices1="";

		     //for(int item : indices) // here we can select only top N indices(features)
		     //	if(item!=0)
	        	// indices1+=Integer.toString(item)+",";
		    for(int i=0;i<(indices.length)/4;i++){	
		    	int item= indices[i];
		         if(item!=0)
		        	 indices1+=Integer.toString(item)+",";
		    }
		     //
		     remove.setAttributeIndices(indices1+"last"); //Utils.arrayToString(indices)
		     remove.setInvertSelection(true);//remove not selected features
		     remove.setInputFormat(train);
		     instNew = Filter.useFilter(train, remove);
		     remove.setAttributeIndices(indices1+"last"); //Utils.arrayToString(indices)
		     remove.setInvertSelection(true);//remove not selected features
		     remove.setInputFormat(test1);//newTest);//test1);//newTest);//test1);//kk
		     Instances instTest = Filter.useFilter(test1, remove);//newTest,remove);//test1, remove);//newTest,remove);//kk

		     System.out.println("attributes number:"+instNew.numAttributes());
		     System.out.println("new attributes number:"+instNew.numAttributes());
		     System.out.println("new attributes class index:"+instNew.classIndex());

			/*
	        System.out.println("Before");
	        for(int i=0; i<data.numAttributes(); i=i+1)
	        {
	            System.out.println("Nominal? "+data.attribute(i).isNominal());
	        }

	        System.out.println("After");
	        for(int i=0; i<data.numAttributes(); i=i+1)
	        {
	            System.out.println("Nominal? "+newData.attribute(i).isNominal());
	        }
			 */
			/*kkkk
	        //split data to train and test
	        newData.randomize(new java.util.Random(0));
	        int trainSize = (int) Math.round(newData.numInstances() * 70/ 100);
	        int testSize = newData.numInstances() - trainSize;
	        Instances train = new Instances(newData, 0, trainSize);
	        Instances test1 = new Instances(newData, trainSize, testSize);
			*/
			//Instances train = new Instances(newData, 0, newData.numInstances());
			//!!!!!remove the above one if you did split
		        //split data to train and test
		     /*
		     instNew.randomize(new java.util.Random(0));
		     int trainSize = (int) Math.round(instNew.numInstances() * 70/ 100);
		     int testSize = instNew.numInstances() - trainSize;
		     Instances train = new Instances(instNew, 0, trainSize);
		     Instances test1 = new Instances(instNew, trainSize, testSize);
				*/
				//Instances train = new Instances(newData, 0, newData.numInstances());
	

			//----------------SVM

			String  OptionsC="-C 1.0 -L 0.001 -P 1.0E-12 -N 0 -V -1 -W 1 -K \"weka.classifiers.functions.supportVector.PolyKernel -E 1.0 -C 250007\" -calibrator \"weka.classifiers.functions.Logistic -R 1.0E-8 -M -1 -num-decimal-places 4\"";
			SMO svm= new SMO();
			svm.setOptions(weka.core.Utils.splitOptions(OptionsC));
			svm.buildClassifier(instNew);
			Evaluation eval = new Evaluation(instNew);
			eval.evaluateModel(svm, instTest);
			System.out.println(eval.toSummaryString("\nSVM Results\n======\n", false));
			System.out.println("TP:"+eval.truePositiveRate(1)+" FP:"+eval.falsePositiveRate(1)+" Area under ROC:"+ eval.areaUnderROC(1));
			System.out.println("TP:"+eval.truePositiveRate(0)+" FP:"+eval.falsePositiveRate(0)+" Area under ROC:"+ eval.areaUnderROC(1));
			System.out.println("Preciosion:"+eval.precision(1));
			System.out.println("Recall:"+eval.recall(1));
			System.out.println("Fmeature:"+eval.fMeasure(1));
			
	/*     
			//------------------DecisionTree
	        String OptionsC ="-C 0.25 -M 2";      // create Cobweb clster  
			J48 tree = new J48();         // new instance of tree
			tree.setOptions(weka.core.Utils.splitOptions(OptionsC));     // set the options
			tree.buildClassifier(instNew);   // build classifier
			// evaluate classifier and print some statistics
			Evaluation eval = new Evaluation(instNew);
			eval.evaluateModel(tree, instTest);
			System.out.println(eval.toSummaryString("\nDecision Tree Results\n======\n", false));
			System.out.println("TP:"+eval.truePositiveRate(1)+" FP:"+eval.falsePositiveRate(1)+" Area under ROC:"+ eval.areaUnderROC(1));
			System.out.println("TP:"+eval.truePositiveRate(0)+" FP:"+eval.falsePositiveRate(0)+" Area under ROC:"+ eval.areaUnderROC(1));

			System.out.println("Preciosion:"+eval.precision(1));
			System.out.println("Recall:"+eval.recall(1));
			System.out.println("Fmeature:"+eval.fMeasure(1));
*/
/*
			//-----------------RandomForest
	        String OptionsC="-K 0 -M 1.0 -V 0.001 -S 1";
			RandomForest rf = new RandomForest();         // new instance of tree
			rf.setOptions(weka.core.Utils.splitOptions(OptionsC));     // set the options
			rf.buildClassifier(instNew);   // build classifier
			// evaluate classifier and print some statistics
			Evaluation eval = new Evaluation(instNew);//newData);
			
			eval.evaluateModel(rf, instTest);//test1);
			
			System.out.println(eval.toSummaryString("\nRandomForest Results\n======\n", false));
			System.out.println("TP:"+eval.truePositiveRate(1)+" FP:"+eval.falsePositiveRate(1)+" Area under ROC:"+ eval.areaUnderROC(1));
			System.out.println("TP:"+eval.truePositiveRate(0)+" FP:"+eval.falsePositiveRate(0)+" Area under ROC:"+ eval.areaUnderROC(1));
			System.out.println("Preciosion:"+eval.precision(1));
			System.out.println("Recall:"+eval.recall(1));
			System.out.println("Fmeature:"+eval.fMeasure(1));
*/
			// generate curve
				generateROC(eval);

			//remove instances
		     //Instances       inst=new Instances(data);






		}catch(Exception e){
			e.printStackTrace();
		}
	}
	public static void generateROC(Evaluation eval) {
		// generate curve
		ThresholdCurve tc = new ThresholdCurve();
		int classIndex = 1;
		Instances result = tc.getCurve(eval.predictions(), classIndex);

		// plot curve
		ThresholdVisualizePanel vmc = new ThresholdVisualizePanel();
		vmc.setROCString("(Area under ROC = " + 
				Utils.doubleToString(tc.getROCArea(result), 4) + ")");
		vmc.setName(result.relationName());
		PlotData2D tempd = new PlotData2D(result);
		tempd.setPlotName(result.relationName());
		tempd.addInstanceNumberAttribute();
		// specify which points are connected
		boolean[] cp = new boolean[result.numInstances()];
		for (int n = 1; n < cp.length; n++)
			cp[n] = true;
		try {
			tempd.setConnectPoints(cp);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		// add plot
		try {
			vmc.addPlot(tempd);
		} catch (Exception e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		// display curve
		String plotName = vmc.getName(); 
		final javax.swing.JFrame jf = 
				new javax.swing.JFrame("Weka Classifier Visualize: "+plotName);
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
	protected static int[] infoGain(Instances data) throws Exception {
		System.out.println("\n Feature Selection: info-Gain \n ");
		AttributeSelection attsel = new AttributeSelection();
		InfoGainAttributeEval eval = new InfoGainAttributeEval();
		Ranker search = new Ranker();
		attsel.setEvaluator(eval);
		attsel.setSearch(search);
	    attsel.SelectAttributes(data);
	    int[] indices = attsel.selectedAttributes();
	    
	    System.out.println("selected attribute indices (starting with 0):\n" + Utils.arrayToString(indices));
	    return indices;
	}
	protected static int[] Correlation(Instances data) throws Exception {
		System.out.println("\n Feature Selection: info-Gain \n ");
		AttributeSelection attsel = new AttributeSelection();
		CorrelationAttributeEval eval = new CorrelationAttributeEval();
		Ranker search = new Ranker();
		attsel.setEvaluator(eval);
		attsel.setSearch(search);
	    attsel.SelectAttributes(data);
	    int[] indices = attsel.selectedAttributes();
	    
	    System.out.println("selected attribute indices (starting with 0):\n" + Utils.arrayToString(indices));
	    return indices;
	}

}
