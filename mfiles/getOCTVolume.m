function [ OCTVolume ] = getOCTVolume(hObject, eventdata, handles)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

% Find which pose we want the OCT Volume for
currentpose = handles.posenumber;

% Get the path, and xml file name associated with the current pose
Path_xml = strcat(handles.Path_poses,'/',handles.Poses(currentpose).name);
File_xml = handles.XMLs{currentpose};

% Read the xml file for this pose
xDoc = xmlread(strcat(Path_xml, '/', File_xml));

% Find all the <TotalVolume> elements (should only be one) in the xml. 
% The getElementsByTagName method returns a list that contains information 
% about the child nodes.  In this case, <TotalVolume> has no child nodes,
% so we will just get the first item (item 0 because xml uses java and the
% first element in java is 0, not 1 like in matlab).  Then, grab the data
% (volume) of this element.
TotalVolumeList = xDoc.getElementsByTagName('TotalVolume');
TotalVolumeTag = TotalVolumeList.item(0);
OCTVolume = str2double(TotalVolumeTag.getFirstChild.getData);

end

