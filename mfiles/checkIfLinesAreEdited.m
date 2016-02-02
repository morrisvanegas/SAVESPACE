function [ output ] = checkIfLinesAreEdited( hObject, eventdata, handles )
%checkIfLinesAreEdited 
%   This functions checks if ANY lines in all the images inside ONE pose
%   are edited.  Essentially, its just a parameter to tell me how well the
%   algorithm is doing by determining how often the user edits the line,
%   and how often they leave it alone because the lines are a good fit.

% need to instantiate because of for loop
output = 'maybe';

% compare current with original layers, for all images
for i = 1:length(handles.meta.Layers)
    % grab the current and original layers
    A = handles.meta.Layers{1,i}.CHR.X;
    B = handles.meta.OriginalLayers{1,i}.CHR.X;
    
    % if NOT equal (ie, at least one line was edited)
    if (isequal(A,B)==0)
        output = 'Yes';
        break;
    end
    
    % Else, output that "No," the lines were not edited
    output = 'No';
end

end

