
Path_xml = uigetdir('', 'where is the xml file?');
File_xml = uigetfile(strcat(Path_xml,'/*.xml'), 'Choose the xml file');
xDoc = xmlread(strcat(Path_xml, '/', File_xml));

% Find all the TotalVolume elements (should only be one). 
% The getElementsByTagName method returns 
% a deep list that contains information about the child nodes:
TotalVolumeList = xDoc.getElementsByTagName('TotalVolume');
TotalVolumeTag = TotalVolumeList.item(0);
volume = TotalVolumeTag.getFirstChild.getData

