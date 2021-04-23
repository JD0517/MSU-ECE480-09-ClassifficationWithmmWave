FeatureParsingGUI.m

This is a modified version of the FeatureParsing function for use with the visualizer.

indoor_demo_3D_visualizer_modified.m

This is a modified version of Texas Instuments' overhead_demo_visualizer included in their 
industrial toolbox: https://dev.ti.com/tirex/explore/node?a=VLyFKFf__4.7.0&node=AJoMGA2ID9pCPWEKPi16wg__VLyFKFf__4.7.0&r=VLyFKFf__4.5.1  
Modifications include integrating a trained classification algorithm to make predictions and 
label targets. Functionality added for both live recording and saved fHist playback.

model.mat

This is a trained KNN classification model. This model uses a 'euclidean' distance calculation
and a k value of 12. This model has 3 classes being: 'Human' 'Cat' and 'Other'
