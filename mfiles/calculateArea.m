function [ output ] = calculateArea(hObject, eventdata, handles, specificImage, lowindex_micro, highindex_micro)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

% XML/OCT Heidelberg machine always outputs in millimeters!
% Layers data in micrometers (I know, I dont know why these two use
% different values either)

if specificImage == 0
    im = handles.imgnumber;
else
    im = specificImage;
end
%  in micro meters
XValues = handles.meta.Layers{im}.CHR.Y.*handles.meta.ScaleX;    %.*handles.meta.resize(2); %XValues(end)=2245 microns
YValues = handles.meta.Layers{im}.CHR.X;    % microns
YValues_RPE = handles.meta.Layers{im}.RPE.X;% microns

thickness = YValues - YValues_RPE;

% since um, convert to mm (1 um = .001 mm)

if lowindex_micro == 0
    XValues = XValues;
else
    XValues = XValues(lowindex_micro:highindex_micro);
    thickness = thickness(lowindex_micro:highindex_micro);
end

% AREA UNDER CURVE, use trapz
output_micro = trapz(XValues, thickness);  % microns squared
output = output_micro*.000001;  % millimeters^2

end

