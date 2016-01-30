% This functions segments all frames in all poses using the .xml file
% inside each pose/folder produced by the Heidelberg OCT machine

%% Directories
% Point to the highest directory
Path_poses = uigetdir('', 'Pick the folder (XMLOutput) where directories of poses are saved');

% Obtain list of all things (folders and files) inside Path_xml
directories = dir(Path_poses);

% Create matrix of indeces of row which are folder, NOT files
these_are_dirs = find(vertcat(directories.isdir));

% Remove the first two rows, because they are just pointers.
these_are_dirs = these_are_dirs(3:end);

% Create list of folders (poses) inside of Path_xml
Poses = directories(these_are_dirs, 1);

%% Find the XML files
% Find the associated .xml file inside each pose (folder)
% create a cell array
XMLs = cell(length(Poses), 1);
for i = 1:length(Poses)
    Path = strcat(Path_poses,'/',Poses(i).name,'/*.xml');
    xml = dir(Path);
    XMLs{i} = xml.name;
end

%% Segment the poses
detect = 2;
for i = 1:length(Poses)
    
    % First, if a pose has already been processed (meta.mat and X.mat exist), 
    % load and save meta.mat and X.mat.  DO NOT use read_data_OCTtool, or 
    % else you will overwrite the Volume, and layers you have already
    % processed using the GUI
    
    % get ".../XMLOutput/Pose####"
    Path_xml = strcat(Path_poses,'/',Poses(i).name);
    PoseName = Poses(i).name;
    metamat = strcat(Path_xml, '/', PoseName, '_meta', '.mat');
    Xmat =    strcat(Path_xml, '/', PoseName, '_X', '.mat');
    
    % Check if they exist.  Output values found in here:
    % http://www.mathworks.com/help/matlab/ref/exist.html?refresh=true
    A = exist(metamat,'file');
    B = exist(Xmat,'file');
    

    if (A==2 && B==2)
        disp(strcat(Poses(i).name, ' (', XMLs{i}, ')', ' was already processed'));
    else

        % Segment the Poses, saves the Layers data to File_xml_layers.mat
        Path_xml = strcat(Path_poses,'/',Poses(i).name);
        File_xml = XMLs{i};
        [X, meta]=read_data_OCTtool([Path_xml '/'], File_xml, detect);

        % Add Diameter if doesnt exist
        if (isfield(meta, 'Diameter') == 0)   % Doesn't Exist
            meta.Diameter = 0;
        end
        
        % Add Original Layers if doesnt exist
        if (isfield(meta, 'OriginalLayers') == 0)   % Doesn't Exist
            meta.OriginalLayers = meta.Layers;
        end

        % Add OCT Calculated Volume if doesnt exist
        if (isfield(meta, 'OCTVolume') == 0)   % Doesn't Exist
            meta.OCTVolume = 0;
        end

        % Add TrapVolume (adaptive) if it doesn't exist
        if (isfield(meta, 'TrapVolume') == 0)   % Doesn't Exist
            meta.TrapVolume = 0;
        end
        
        % Add SimpsonVolume (adaptive) if doesnt exist
        if (isfield(meta, 'SimpsonVolume') == 0)   % Doesn't Exist
            meta.SimpsonVolume = 0;
        end
        
        % Add SplineVolume (adaptive) if doesnt exist
        if (isfield(meta, 'SplineVolume') == 0)   % Doesn't Exist
            meta.SplineVolume = 0;
        end

        % Add Unedited_TrapVolume if it doesn't exist
        if (isfield(meta, 'Unedited_TrapVolume') == 0)   % Doesn't Exist
            meta.Unedited_TrapVolume = 0;
        end
        
        % Add Unedited_SimpsonVolume if doesnt exist
        if (isfield(meta, 'Unedited_SimpsonVolume') == 0)   % Doesn't Exist
            meta.Unedited_SimpsonVolume = 0;
        end
        
        % Add Unedited_SplineVolume if doesnt exist
        if (isfield(meta, 'Unedited_SplineVolume') == 0)   % Doesn't Exist
            meta.Unedited_SplineVolume = 0;
        end
        
        % Add Processed if doesnt exist
        if (isfield(meta, 'Processed') == 0)   % Doesn't Exist
            meta.Processed = 'No';
        end
        
        % Add Cell Array 'Edited_Lines' if doesnt exist
        if (isfield(meta, 'Edited_Lines') == 0)   % Doesn't Exist
            meta.Edited_Lines = {'No'};
        end

        % Save meta data to PoseName_meta.mat
        PoseName = Poses(i).name;
        save([Path_xml '/' PoseName '_meta' '.mat'], 'meta');
        save([Path_xml '/' PoseName '_X' '.mat'], 'X');

        disp(strcat(Poses(i).name, ' (', File_xml, ')', ' finished processing'));
    end
end