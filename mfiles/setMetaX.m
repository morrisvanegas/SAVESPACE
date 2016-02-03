function [] = setMetaX( hObject, eventdata, handles, i )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% save data to directory
meta = handles.meta;
X = handles.X;

% get ".../XMLOutput/Pose####"
Path_xml = strcat(handles.Path_poses,'/',handles.Poses(i).name);

% Save meta data to PoseName_meta.mat, inside ".../XMLOutput/Pose###"
PoseName = handles.Poses(i).name;
save([Path_xml '/' PoseName '_meta' '.mat'], 'meta');
save([Path_xml '/' PoseName '_X' '.mat'], 'X');

% Add this pose and its data to the results matrix that is compiling all
% the data to make it easy to do statistical analysis.  Will have to use a
% CELL matrix since we have both string and number data

% load results matrix, or create it if first time
try
    load('results.mat');
catch
    % In case its the first time, or it doesnt exist
    results = {'SubjectName', 'XMLfile', 'NumberOfFrames', 'StudyTime',...
    'StudyDate', 'Angle(deg)', 'Diameter(mm)', 'OCTVolume(mm^2)', ...
    'TrapVolume', 'SimpsonVolume', 'SplineVolume', 'Unedited_TrapVolume',...
    'Unedited_SimpsonVolume', 'Unedited_SplineVolume'};   
end

% check to see if the xml file was already saved before.  If it was, edit
% its values rather than adding a new column
savedXMLs = results(:,2);
comparisons = strcmp(handles.XMLs{i}, savedXMLs) 
[row, col] = find(comparisons);     % Find indeces of nonzero elements

output = cell(1, 14);


if isempty(row)==1  % no nonzero (matches) values were found 
    output{1,1}  = PoseName;
    output{1,2}  = handles.meta.FileName;
    output{1,3}  = handles.meta.NumberOfFrames;
    output{1,4}  = handles.meta.StudyTime;
    output{1,5}  = handles.meta.StudyDate;
    output{1,6}  = handles.meta.Angle(1);
    output{1,7}  = handles.meta.Diameter;
    output{1,8}  = handles.meta.OCTVolume;
    output{1,9}  = handles.meta.TrapVolume;
    output{1,10} = handles.meta.SimpsonVolume;
    output{1,11} = handles.meta.SplineVolume;
    output{1,12} = handles.meta.Unedited_TrapVolume;
    output{1,13} = handles.meta.Unedited_SimpsonVolume;
    output{1,14} = handles.meta.Unedited_SplineVolume;
    
    results = [results; output];
else
    n = row(1);
    results{n,1}  = PoseName;
    results{n,2}  = handles.meta.FileName;
    results{n,3}  = handles.meta.NumberOfFrames;
    results{n,4}  = handles.meta.StudyTime;
    results{n,5}  = handles.meta.StudyDate;
    results{n,6}  = handles.meta.Angle(1);
    results{n,7}  = handles.meta.Diameter;
    results{n,8}  = handles.meta.OCTVolume;
    results{n,9}  = handles.meta.TrapVolume;
    results{n,10} = handles.meta.SimpsonVolume;
    results{n,11} = handles.meta.SplineVolume;
    results{n,12} = handles.meta.Unedited_TrapVolume;
    results{n,13} = handles.meta.Unedited_SimpsonVolume;
    results{n,14} = handles.meta.Unedited_SplineVolume;
    
end
    
% save the results for statistical analysis use
save('results.mat', 'results');

end

