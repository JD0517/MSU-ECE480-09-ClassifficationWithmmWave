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

function result = FeatureParsing(filename)   
    
    disp(filename);
    
    file = load(filename, '-mat');

    targets_list = file.labels;

    % Pull out important data for each index
    % Cell array for storing the resultant data vectors
    targets_data = cell(1,256);

    data_size = length(file.data);
    for frame_index = 1:data_size 
        %check if indexArray available at this index, if not move on to next
        %index
        if isempty(file.data(frame_index).indexArray)
            continue
        else
            % Get a list of all (with valid target ID) the indexes present in this frame
            if (unique(file.data(frame_index).indexArray)< 249)
                index_set = unique(file.data(frame_index).indexArray);
            else
                continue;
            end
            
        end
        for i = 1:length(index_set)
            current_index = index_set(i);
            
            % For each valid index, pull out the valid data and add it to the
            % valid data cell array
            arr = (file.data(frame_index).indexArray);
            indx = find(abs(arr - current_index) == 0);
            %indx = find(fHist(frame_number).indexArray == current_index);
            
            if(length(file.data(frame_index).pointCloud(4,:)) < length(indx))
                % Somehow the list of valid indexes is longer than the
                % actual number of datapoints??????
                continue;
            end
            
            currDoppler = file.data(frame_index).pointCloud(4, indx);     % Extract doppler 
            currPower = file.data(frame_index).pointCloud(5, indx);     % Extract SNR
            
            %Extract position information
            range = file.data(frame_index).pointCloud(1, indx);
            azim = file.data(frame_index).pointCloud(2, indx);
            elev = file.data(frame_index).pointCloud(3, indx);
            
            %Spherical to cartesian
            xPos = range.*cos(elev).*sin(azim);
            yPos = range.*cos(elev).*cos(azim);
            zPos = range.*sin(elev);
            
            %Find Dimensions
            xDim = max(xPos)-min(xPos);
            yDim = max(yPos)-min(yPos);
            zDim = max(zPos)-min(zPos);

            % CoM - Center of Mass
            udCoM = sum(currPower.*currDoppler)/sum(currPower);
            
            if ~isnan(udCoM)
                % Only continue if the data is valid
                udUpperEnv = max(currDoppler - udCoM);
                udLowerEnv = min(currDoppler - udCoM);
                data = [udCoM, udUpperEnv, udLowerEnv, xDim, yDim, zDim];
                
                if isempty(targets_data{current_index + 1})
                    % Just assign the cell array
                    targets_data{current_index + 1} = data;
                else 
                    % Get the existing array, append the new data, and put it back
                    olddata = targets_data{current_index + 1};
                    newmatrix = [olddata; data];
                    targets_data{current_index + 1} = newmatrix;
                end
            end


        end
    end
    
    stepsize = 1;
    windowsize = 20;
    bigarray = zeros(1,8);
    labelarray = 0;
    bigarray = [];
    labelarray = [];
    
    for current_target_index = 1:240
        num_frames = length(targets_data{current_target_index});
        if num_frames == 0
            continue
        end
        
        % For each valid array index, compute all the cool stuff and add it to
        % the end of the big data list
        current_target = current_target_index - 1;
        
        data = targets_data{current_target_index};
        label = targets_list(current_target_index);
        
        if num_frames < windowsize && num_frames > 7
            udCoM = data(1:num_frames,1);
            udUpperEnv = data(1:num_frames,2);
            udLowerEnv = data(1:num_frames,3);
            
            % Actual features used
            % Doppler features
            udBW = max(udUpperEnv) - min(udLowerEnv);
            udOffset = mean(udUpperEnv) - mean(udLowerEnv);
            udTorsoBW = min(udUpperEnv) - max(udLowerEnv);
            %udTorsoBW = max(udUpperEnv) - min(udLowerEnv);
            udCenterMassAvg = mean(udCoM);
            udCenterMassStd = std(udCoM);
            
            % Geometric Features
            xBWAvg = mean(data(1:num_frames,4));
            yBWAvg = mean(data(1:num_frames,5));
            zBWAvg = mean(data(1:num_frames,6));
            
            newdata = [udBW udOffset udTorsoBW udCenterMassAvg udCenterMassStd xBWAvg yBWAvg zBWAvg];
            
            %Probably isnt required anymore
            if isnan(newdata)
                continue
            end
            
            bigarray = [bigarray; newdata];
            labelarray = [labelarray label];
        end
            
        for data_index = 1:stepsize:(num_frames - windowsize)
            udCoM = data(data_index:(data_index + windowsize),1);
            udUpperEnv = data(data_index:(data_index + windowsize),2);
            udLowerEnv = data(data_index:(data_index + windowsize),3);
            
            % Actual features used
            % Doppler features
            udBW = max(udUpperEnv) - min(udLowerEnv);
            udOffset = mean(udUpperEnv) - mean(udLowerEnv);
            %udTorsoBW = min(udUpperEnv) - max(udLowerEnv);
            udTorsoBW = max(udUpperEnv) - min(udLowerEnv);
            udCenterMassAvg = mean(udCoM);
            udCenterMassStd = std(udCoM);
            
            %Geometric Features
            xBWAvg = mean(data(data_index:(data_index + windowsize),4));
            yBWAvg = mean(data(data_index:(data_index + windowsize),5));
            zBWAvg = mean(data(data_index:(data_index + windowsize),6));
            
            newdata = [udBW udOffset udTorsoBW udCenterMassAvg udCenterMassStd xBWAvg yBWAvg zBWAvg];
            
            %Probably isnt required anymore
            if isnan(newdata)
                continue
            end
            
            bigarray = [bigarray; newdata];
            labelarray = [labelarray label];
        end
    end
    
    result = {bigarray, labelarray};
end
