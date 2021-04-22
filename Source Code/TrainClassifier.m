% BSD 3-Clause License
% 
% Copyright (c) 2020, 00Nave198
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% 3. Neither the name of the copyright holder nor the names of its
%    contributors may be used to endorse or promote products derived from
%    this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function result = TrainClassifier(files)

    % Example data folder.  Replace with your data folders location
    %datafolder = '../data/labeled';
    
    datafolder = 'E:\Classes\ECE 480\Data\PointCloud\Labeled';
    addpath(datafolder); 

    bigarray = [];
    labels = [];
    
    for i = 1:length(files)
        output = FeatureParsing(files{i});
        bigarray = [bigarray; output{1}];
        labels = [labels output{2}];
    end

    % Different possible classifiers.  Hyperparameter optimization may be
    % useful

    % fitcsvm linear
    %svm = fitcsvm(bigarray, labels)

    % fitckernel
    %svm = fitckernel(bigarray, labels)

    % fitcsvm rbf
    %svm = fitcsvm(bigarray, labels, 'KernelFunction','rbf')

    % These are able to do multiclass, simply add more labeles to the data to
    % perform multiclass classification
    % ECOC
    %svm = fitcecoc(bigarray, labels)
    % KNN
    svm = fitcknn(bigarray, labels, 'NumNeighbors', 12) 

    % Save classifier to file
    %save('svm.mat', 'svm', 'svmpath');

    result = svm;

end% BSD 3-Clause License
% 
% Copyright (c) 2020, 00Nave198
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are met:
% 
% 1. Redistributions of source code must retain the above copyright notice, this
%    list of conditions and the following disclaimer.
% 
% 2. Redistributions in binary form must reproduce the above copyright notice,
%    this list of conditions and the following disclaimer in the documentation
%    and/or other materials provided with the distribution.
% 
% 3. Neither the name of the copyright holder nor the names of its
%    contributors may be used to endorse or promote products derived from
%    this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
% DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
% FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
% DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
% SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
% OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
% OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

function result = TrainClassifier(files)

    % Example data folder.  Replace with your data folders location
    %datafolder = '../data/labeled';
    
    datafolder = 'E:\Classes\ECE 480\Data\PointCloud\Labeled';
    addpath(datafolder); 

    bigarray = [];
    labels = [];
    
    for i = 1:length(files)
        output = FeatureParsing_modified(files{i});
        bigarray = [bigarray; output{1}];
        labels = [labels output{2}];
    end

    % Different possible classifiers.  Hyperparameter optimization may be
    % useful

    % fitcsvm linear
    %svm = fitcsvm(bigarray, labels)

    % fitckernel
    %svm = fitckernel(bigarray, labels)

    % fitcsvm rbf
    %svm = fitcsvm(bigarray, labels, 'KernelFunction','rbf')

    % These are able to do multiclass, simply add more labeles to the data to
    % perform multiclass classification
    % ECOC
    %svm = fitcecoc(bigarray, labels)
    % KNN
    svm = fitcknn(bigarray, labels, 'NumNeighbors', 12) 

    % Save classifier to file
    %save('svm.mat', 'svm', 'svmpath');

    result = svm;

end
