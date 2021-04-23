all_files = {'labeled_fHistRT_s01_a02.mat', 'labeled_fHistRT_s01_a03.mat', 'labeled_fHistRT_s01_a04.mat', ...
'labeled_fHistRT_s01_a05.mat', 'labeled_fHistRT_s01_a06.mat', 'labeled_fHistRT_s01_a07.mat', 'labeled_fHistRT_s01_a08.mat', ...
'labeled_fHistRT_s01_a09.mat', 'labeled_fHistRT_s02_a01.mat', 'labeled_fHistRT_s02_a02.mat', 'labeled_fHistRT_s02_a03.mat', ...
'labeled_fHistRT_s02_a06.mat', 'labeled_fHistRT_s02_a07.mat', 'labeled_fHistRT_s02_a08.mat', 'labeled_fHistRT_s02_a10.mat' ...
'labeled_fHistRT_s02_a10.mat', 'labeled_fHistRT_s03_a12.mat','labeled_fHistRT_s03_a13.mat', 'labeled_fHistRT_s03_a14.mat', ...
'labeled_fHistRT_s03_a15.mat', 'labeled_fHistRT_s03_a16.mat','labeled_fHistRT_s03_a17.mat', 'labeled_fHistRT_s03_a18.mat', ...
'labeled_fHistRT_s03_a19.mat', 'labeled_fHistRT_s03_a20.mat', 'labeled_fHistRT_s03_a21.mat', ...
'labeled_fHistRT_s03_a22.mat', 'labeled_fHistRT_s03_a23.mat', 'labeled_fHistRT_s03_a24.mat' 'labeled_fHistRT_s03_a25.mat', 'labeled_fHistRT_s03_a26.mat', 'labeled_fHistRT_s03_a27.mat', 'labeled_fHistRT_s03_a28.mat', ...
'labeled_fHistRT_s03_a29.mat', 'labeled_fHistRT_s03_a30.mat', 'labeled_fHistRT_s03_a31.mat', 'labeled_fHistRT_s03_a32.mat', ...
'labeled_fHistRT_s03_a33.mat', 'labeled_fHistRT_s03_a34.mat', 'labeled_fHistRT_s03_a35.mat', 'labeled_fHistRT_s03_a36.mat', ...
'labeled_fHistRT_s03_a37.mat', 'labeled_fHistRT_s03_a38.mat', 'labeled_fHistRT_s03_a39.mat', 'labeled_fHistRT_s03_a40.mat', ...
'labeled_fHistRT_s04_a01.mat', 'labeled_fHistRT_s04_a02.mat', 'labeled_fHistRT_s04_a03.mat', 'labeled_fHistRT_s04_a04.mat', ...
'labeled_fHistRT_s04_a05.mat', 'labeled_fHistRT_s04_a06.mat', 'labeled_fHistRT_s04_a07.mat', 'labeled_fHistRT_s04_a08.mat', ...
'labeled_fHistRT_s04_a09.mat'};

all_test_labels = [];
guesses = [];

for k = 1:length(all_files)
    
    before_k = all_files(1:k-1);
    after_k = all_files(k+1:length(all_files));
    
    train_files = [before_k, after_k];
    test_file = all_files(k);
    
    model = TrainClassifier(train_files);
        
    test_cont = FeatureParsing(test_file{1,1});
    test_data = test_cont{1};
    test_labels = test_cont{2};
    
    all_test_labels = [all_test_labels test_labels];
    
    for j = 1:length(test_data)
        [guess, other] = predict(model, test_data(j,:));
        guesses = [guesses guess];
        label = test_labels(j);
    end
end

[confMat, gorder] = confusionmat(all_test_labels, guesses);

numClasses = size(confMat,1);
totalSamples = sum(sum(confMat));

[TP,TN,FP,FN,accuracy,recall,precision,f_score] = deal(zeros(numClasses,1));
for i = 1:numClasses
    tempMat = confMat;
    tempMat(:,i) = []; 
    tempMat(i,:) = [];
    
    TN(i) = sum(sum(tempMat));          %True Negatives
    TP(i) = confMat(i,i);               %True Positives
    FN(i) = sum(confMat(i,:))-TP(i);    %False Negatives                  
    FP(i) = sum(confMat(:,i))-TP(i);    %False Positives
    
    accuracy(i) = (TP(i) + TN(i)) / totalSamples;
    recall(i) = TP(i) / (TP(i) + FN(i));
    precision(i) = TP(i) / (TP(i) + FP(i));
    f_score(i) = 2*TP(i)/(2*TP(i) + FP(i) + FN(i));
end
    
confusionchart(confMat);

disp('Accuracy:');
disp(accuracy);

disp('Precision:');
disp(precision);

disp('Recall:');
disp(recall);

disp('F Score:');
disp(f_score);











