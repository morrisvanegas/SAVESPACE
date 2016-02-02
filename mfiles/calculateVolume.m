function [ TrapezoidVolume, SimpsonVolume, SplineVolume ] = calculateVolume(hObject, eventdata, handles)
%calculateVolume Summary of this function goes here
% calculateArea
%   This function takes in a meta struct, find the approriate CHR lines,
%   calculates the area of the choroid in each image, 
% calculateVolume
%   This function now will just calculate total volume using the areas of 
%   each frame calculated in calculateArea.  It will estimate areas between
%   frames a distance x apart using the trapezoidal estimation

% XML/OCT Heidelberg machine always outputs in millimeters!
% Layers data in micrometers (I know, I dont know why these two use
% different values either)

numFrames = handles.meta.NumberOfFrames;
%diameter = handles.meta.Diameter   % mm
diameter = get(handles.unedited_diameter_text, 'Max');

try
    radius = diameter/2;                % mm
catch
    diameter{1}     % just use one.  Not sure why this is a struct only when setMetaX is called, but a double all other times.
    radius = diameter{1}/2;
end

spacing = diameter/(numFrames-1);
xvals = 0:spacing:diameter;

chord = 2*sqrt((radius^2)-(abs(xvals-radius).^2));  % mm


% Find the horizontal value of where the fovea is
imgnumber = (numFrames+1)/2;  % look at the center image for the fovea
Xvalues_short = handles.meta.Layers{imgnumber}.ILM.Y.*handles.meta.ScaleX; %XValues(end)=2245 micron
%Xvalues = handles.meta.Layers{imgnumber}.ILM.Y.*handles.meta.resize(2); %XValues(end)=2245 microns
Data = handles.meta.Layers{imgnumber}.ILM.X;    % in micron
% figure
% imshow(handles.X(:,:,1,imgnumber));
% hold on
% plot(Xvalues_short, Data, 'b','LineWidth',2);
%plot(Xvalues,Data,'r','LineWidth',1);


[Minima,MinIndeces] = findpeaks(Data);  % Index in Data where there are local minima
centerindex = length(Data)/2;           % Index in Data that is the center
[c anindex] = min(abs(MinIndeces - centerindex)); % Which MinIndex is closest to CenterIndex
index = MinIndeces(anindex);             % Index in Data that is closest to the center, that has a minimum


% x=[Xvalues_short(index), Xvalues_short(index)];
% y=[0, Data(index)];
% plot(x,y)


centermicron = round(Xvalues_short(index)); %*handles.meta.ScaleX) % horizontal value, in microns, of fovea
% ScaleX = 3.9;  3.9pixels = 1 millimeters
% http://www.unitconversion.org/typography/pixels-x-to-millimeters-conversion.html
% 1 millimeter = 1000 microns


areas = zeros(1,numFrames);
for i=1:numFrames
    
    width_mm = chord(i);                        % the length, in mm, that we should use for area
    width_micron = width_mm*1000;               % microns
    Xvalues_i = handles.meta.Layers{i}.ILM.Y.*handles.meta.ScaleX; % microns
    %XValues(end)=2245 micrometers

    % determine index of width of chord centered at centermilli
    lowend = round(centermicron-width_micron/2); highend = round(centermicron+width_micron/2);  % micron values
    % what is the index 
    [c lowindex_micro] = min(abs(Xvalues_i-lowend));   % Finds first index that is closest.
    %lowindex_micro
    %Xvalues_i(lowindex_micro)
    [c highindex_micro] = min(abs(Xvalues_i-highend));   % Finds first index that is closest.
    %closestValue = f(idx) % Finds first one only!
    
    
    if (i==1 || i==numFrames)
        areas(i) = 0; %calculateArea(hObject, eventdata, handles, i, 0, 0);
    else
        areas(i) = calculateArea(hObject, eventdata, handles, i, lowindex_micro, highindex_micro); % mm^2
    end
end

%figure
%plot(areas);

frames = 1:numFrames;
% trapezoidal rule
TrapezoidVolume = trapz(frames, areas);  % millimeters^2
% simpson rule
SimpsonVolume = simps(frames, areas);
% spline
pp = spline(frames, areas);
SplineVolume = ppint(pp, frames(1), frames(end));



end