function [ Path_poses, Poses, XMLs] = getPoses()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% user inputs the location of the folder containing the directory of poses,
% with a .xml file and a .pdf of the middle frame segmented from the OCT
% machine inside each directory
Path_poses = uigetdir('', 'Pick the folder (XMLOutput) where directories of poses are saved');
%File_xml = uigetfile(strcat(Path_xml,'/*.xml'), 'Choose the xml file');

% Obtain list of all things (folders and files) inside Path_xml
directories = dir(Path_poses);

% Create matrix of indeces of row which are folder, NOT files
these_are_dirs = find(vertcat(directories.isdir));

% Remove the first two rows, because they are just pointers.
these_are_dirs = these_are_dirs(3:end);

% Create list of folders (poses) inside of Path_xml
Poses = directories(these_are_dirs, 1);

% Find the associated .xml file inside each pose (folder)
% create a cell array
XMLs = cell(length(Poses), 1);
for i = 1:length(Poses)
    Path = strcat(Path_poses,'/',Poses(i).name,'/*.xml');
    xml = dir(Path);
    XMLs{i} = xml.name;

end

