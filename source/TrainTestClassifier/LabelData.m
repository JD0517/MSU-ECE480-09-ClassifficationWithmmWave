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

% Script to help classify raw data
done = 0;

% Put the data input and output directory here
%%%%%%% EDIT THIS LINE %%%%%%
cd 'E:\Data\PointCloud\Unlabeled'

while done == 0
    
    % prompt the user for the file to label
    filename = input('Enter the file you would like to label: ', 's');
    if strcmp(filename, 'done')
        done = 1;
        break;
    end
    
    % Load the data from file
    % if it fails here your file is wrong
    oldfile = load(filename, '-mat');
    
    % Prompt user for a list of all the human targets
    human = input('Enter the human targets for the data file: ');
    
    % Prompt user for a list of all the cat targets
    cat = input('Enter the cat targets for the data file: ');
    
    % Generate an array for all targets
    labels = zeros(256,1);
    for i = 1:length(human)
        target = human(i);
        labels(target+1) = 1;
    end
    
    for i = 1:length(cat)
        target = cat(i);
        labels(target+1) = 2;
    end
    
    % Save the file
    data = oldfile.fHist;
    % On windows
    newfilename = strcat(pwd,'\','labeled_', filename);
    
    % On macos or linux
    %newfilename = strcat(pwd,'/','labeled_', filename);
    
    save(newfilename, 'data', 'labels');
end