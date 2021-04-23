This guide provides an overview of each Matlab file and how to use them to train and 
test a multi-class classification algorithm. Matlab Statistics and Machine Learning 
Toolbox is required to use these files.

Files:

	LabelData.m
	FeatureParsing.m
	TrainClassifier.m
	TestClassifier.m

LabelData.m

	This is a Matlab script that can be used to label data. Before running this script
	the user must  know the target IDs for each target in a specific data file. The user must also
	edit line 36 to reflect the correct data directory. Upon running this script the user will be 
	prompted to enter the file that they want to label. Upon entering the file name the user 
	will be prompted to enter a list containing the target IDs for human targets (e.g. enter [0 1 2]
	if target ID 0, 1, and 2 are human). Next the user will be prompted to enter a list containing the 
	target IDs for all the cat targets (or other distinguishable non human class). The remaining targets
	will be labeled as 'other.' The labeled	file will then be saved with the 'labeled_' prefix to the 
	previously specified directory.

FeatureParsing.m

	This is a function that extracts features from the data to train on the algorithm. The input is a 
	labeled data file. The output is a tuple of arrays. The first array contains all of the extracted 
	features from the data. Each of the 8 columns correspond to a specific feature. The features listed 
	in order: udBW; udOffset; udTorsoBW; udCenterMassAvg; udCenterMassStd; xBWAvg; yBWAvg; zBWAvg. 
	The second array contains the labels associated with the target for each row  in the first array.
	
TrainClassifier.m

	This is a function that trains and returns a classification model. The input to this function is
	an array of file names. The path for the directory containing the labeled data files must be 
	specified in line 36. This function calls the FeatureParsing function for each file in the list 
	of inputs it then trains a classification model on all of the extracted features. Specific 
	classification model parameters can be adjusted e.g. NumNeighbors for KNN etc. 

TestClassifier.m

	This script uses the Leave-One-Out Cross Validation method (LOOCV) to evaluate the performance of a 
	specific clasification algorithm. After using the LOOCV method and storing all guesses along with 
	their corresponding label a confusion matrix is computed. The script then computes and displays the 
	Accuracy, Precision, Recall, and F1 Score.
