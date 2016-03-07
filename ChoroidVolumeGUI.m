function varargout = ChoroidVolumeGUI(varargin)
% CHOROIDVOLUMEGUI MATLAB code for ChoroidVolumeGUI.fig
%      CHOROIDVOLUMEGUI, by itself, creates a new CHOROIDVOLUMEGUI or raises the existing
%      singleton*.
%
%      H = CHOROIDVOLUMEGUI returns the handle to a new CHOROIDVOLUMEGUI or the handle to
%      the existing singleton*.
%
%      CHOROIDVOLUMEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CHOROIDVOLUMEGUI.M with the given input arguments.
%
%      CHOROIDVOLUMEGUI('Property','Value',...) creates a new CHOROIDVOLUMEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ChoroidVolumeGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ChoroidVolumeGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ChoroidVolumeGUI

% Last Modified by GUIDE v2.5 19-Aug-2015 11:21:02

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ChoroidVolumeGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @ChoroidVolumeGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before ChoroidVolumeGUI is made visible.
function ChoroidVolumeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ChoroidVolumeGUI (see VARARGIN)

% From here: "http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3833954/" -> "The 
% choroidal thickness was calculated as the distance between the two
% segments."



% Ask user to point to directory where poses (folder) are
detect = 2;
[handles.Path_poses, handles.Poses, handles.XMLs] = getPoses();
handles.Path_xml = strcat(handles.Path_poses,'/',handles.Poses(1).name);

% Load the X and meta data of the first pose
handles.posenumber = 1;
[handles.X, handles.meta] = getMetaX(hObject, eventdata, handles, handles.posenumber);



% Load the first image, always
handles.imgnumber = 1;
imshow(handles.X(:,:,1,handles.imgnumber));
hold on;
handles.RPE = plot(handles.meta.Layers{handles.imgnumber}.RPE.Y.*handles.meta.resize(2),handles.meta.Layers{handles.imgnumber}.RPE.X,'g','LineWidth',2);
handles.CHR = plot(handles.meta.Layers{handles.imgnumber}.CHR.Y.*handles.meta.resize(2),handles.meta.Layers{handles.imgnumber}.CHR.X,'r','LineWidth',2);
%handles.ILM = plot(handles.meta.Layers{handles.imgnumber}.ILM.Y.*handles.meta.resize(2),handles.meta.Layers{handles.imgnumber}.ILM.X,'b','LineWidth',2);

%handles.meta.Layers{im}.CHR.Y_old = thisisoldnow;
handles.meta.Layers{handles.imgnumber}.CHR.X_old = handles.meta.Layers{handles.imgnumber}.CHR.X;     % need to save an old CHR values to be able to undo.
handles.meta.Layers{handles.imgnumber}.CHR.Y_old = handles.meta.Layers{handles.imgnumber}.CHR.Y.*handles.meta.resize(2);     % need to save an old CHR values to be able to undo.


% update all information
update_static_values(hObject, eventdata, handles);


% Initialize slider values
handles.unitstep = 10; min = 0; max = 100; start = 50;
handles.max = max;
slider_step(1) = handles.unitstep/(max-min);
slider_step(2) = handles.unitstep/(max-min);
set(handles.sensitivity_slider,'sliderstep',slider_step,'max',max,'min',min,'Value',start);
set(handles.sensitivity_text, 'String', start);

% Choose default command line output for ChoroidVolumeGUI
handles.output = hObject;

% Enlarge figure to full screen.
set(gcf, 'units','normalized','outerposition',[0 0 1 1]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ChoroidVolumeGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ChoroidVolumeGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when called.
function update_static_values(hObject, eventdata, handles)
% hObject    handle to prev_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% edit posename, processed pose, edited any lines, current pose, totalpose,
% current image, total image, study date, study time, chr volume, chr area

% Subject Name
subject_name = handles.Poses(handles.posenumber).name;
set(handles.subject_text, 'String', subject_name); 
% Processed pose?
set(handles.processed_text, 'String', handles.meta.Processed);
if strcmp(handles.meta.Processed,'Yes')
    set(handles.processed_text,'BackgroundColor','green');
elseif strcmp(handles.meta.Processed,'No')
    set(handles.processed_text,'BackgroundColor','white');
end
% Edited any lines?
set(handles.edited_text, 'String', checkIfLinesAreEdited(hObject, eventdata, handles));
% Current Pose
set(handles.currentpose_text, 'String', handles.posenumber);
% Total Poses in directory
set(handles.totalposes_text, 'String', length(handles.Poses));
% Current image
set(handles.image_text,'String', handles.imgnumber);
% Total Images Taken
set(handles.totalimages_text, 'String', handles.meta.NumberOfFrames);
% Study Date
set(handles.date_text, 'String', handles.meta.StudyDate);
% Study Time
set(handles.time_text, 'String', handles.meta.StudyTime);
% Diameter (of thickness map circles)
dia = getOCTCircleDiameter(hObject, eventdata, handles);
set(handles.unedited_diameter_text, 'Max', dia);
% CHR area
set(handles.area_text, 'String', calculateArea(hObject, eventdata, handles, 0, 0, 0));
% CHR volumes
% --- OCT Volume
if (get(handles.unedited_octvolume_text, 'Max') == 0)
    octvol = getOCTVolume(hObject, eventdata, handles);
    %set(handles.unedited_octvolume_text, 'Max', octvol);
    set(handles.octvolume_text, 'String', octvol);
    handles.meta.OCTVolume = octvol;
end
% --- unedited volumes (trap, simpson, spline)
if (get(handles.unedited_trapvolume_text, 'Max') == 0)
    [Trapezoid, Simpson, SplineVolume] = calculateVolume(hObject, eventdata, handles);
    
    set(handles.unedited_trapvolume_text, 'Max', Trapezoid);
    handles.meta.Unedited_TrapVolume = Trapezoid;
    
    set(handles.unedited_simpsonvolume_text, 'Max', Simpson);
    handles.meta.Unedited_SimpsonVolume = Simpson;
    
    set(handles.unedited_splinevolume_text, 'Max', SplineVolume);
    handles.meta.Unedited_SplineVolume = SplineVolume;
end
% --- update the adaptive volumes (trap, simpson, spline), the ones
% changing with the edits of the line
[Trapezoid, Simpson, SplineVolume] = calculateVolume(hObject, eventdata, handles);
set(handles.trapvolume_text, 'String', Trapezoid);
set(handles.simpsonvolume_text, 'String', Simpson);
set(handles.splinevolume_text, 'String', SplineVolume);
handles.meta.TrapVolume = Trapezoid;
handles.meta.SimpsonVolume = Simpson;
handles.meta.SplineVolume = SplineVolume;


% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in prev_pushbutton.
function prev_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to prev_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imgnumber = handles.imgnumber;
if (imgnumber < 1)
    imgnumber = 1;
elseif (imgnumber == 1)
    imgnumber = 1;
else
    imgnumber = imgnumber-1;
end
handles.imgnumber = imgnumber;
%set(handles.image_text,'String',num2str(handles.imgnumber));
imshow(handles.X(:,:,1,handles.imgnumber));
handles.RPE = plot(handles.meta.Layers{handles.imgnumber}.RPE.Y.*handles.meta.resize(2),handles.meta.Layers{handles.imgnumber}.RPE.X,'g','LineWidth',2);
handles.CHR = plot(handles.meta.Layers{handles.imgnumber}.CHR.Y.*handles.meta.resize(2),handles.meta.Layers{handles.imgnumber}.CHR.X,'r','LineWidth',2);
% update all information
update_static_values(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in next_pushbutton.
function next_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to next_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

imgnumber = handles.imgnumber;
totalimg = handles.meta.NumberOfFrames;
if (imgnumber > totalimg)
    imgnumber = totalimg;
elseif (imgnumber == totalimg)
    imgnumber = totalimg;
else
    imgnumber = imgnumber+1;
end
handles.imgnumber = imgnumber;
%set(handles.image_text,'String',num2str(handles.imgnumber));
imshow(handles.X(:,:,1,handles.imgnumber));
handles.RPE = plot(handles.meta.Layers{handles.imgnumber}.RPE.Y.*handles.meta.resize(2),handles.meta.Layers{handles.imgnumber}.RPE.X,'g','LineWidth',2);
handles.CHR = plot(handles.meta.Layers{handles.imgnumber}.CHR.Y.*handles.meta.resize(2),handles.meta.Layers{handles.imgnumber}.CHR.X,'r','LineWidth',2);
% update all information
update_static_values(hObject, eventdata, handles)
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in edit_togglebutton.
function edit_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to edit_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of edit_togglebutton
value = get(hObject,'Value');   % 0=turned off, 1=turned on
switch value
    case 1  % edit turned on, so enable edit panel objects
        set(handles.undo_pushbutton, 'enable', 'off');
        %set(handles.view_pushbutton, 'enable', 'off');
        set(handles.bottom_radiobutton, 'enable', 'off');
        set(handles.top_radiobutton, 'enable', 'off');
        set(handles.sensitivity_slider, 'enable', 'off');
        set(handles.sensitivity_text, 'enable', 'off');
        
        %output = 'filler';
        max_sensitivity = str2double(get(handles.sensitivity_text, 'String'));
        %max_sensitivity = 100;%handles.max;
        n=1;

%         im  = str2double(get(handles.image_text,'String'));
%         XValues = handles.meta.Layers{im}.CHR.Y*handles.meta.resize(2);
%         YValues = handles.meta.Layers{im}.CHR.X;
%         YValues_RPE = handles.meta.Layers{im}.RPE.X;

        ind = [];
        newx = [];
        newy = [];
        but = 1;

        
            while(get(hObject,'Value')==1)  % While edit button is active
                try
                    [x,y,but]=ginput(1);        % Start the cursor for user input
                    
                    im  = str2double(get(handles.image_text,'String'));
                    
                    handles.meta.Layers{im}.CHR.Y_old = handles.meta.Layers{im}.CHR.Y;
                    handles.meta.Layers{im}.CHR.X_old = handles.meta.Layers{im}.CHR.X;
                    
                    XValues = handles.meta.Layers{im}.CHR.Y.*handles.meta.resize(2);
                    YValues = handles.meta.Layers{im}.CHR.X;
                    YValues_RPE = handles.meta.Layers{im}.RPE.X;

                    if(y>handles.meta.Height || y<0)    % if you clicked outside
                        %output = 'stop_edit';               % tell the GUI to stop_edit
                        %exitFcn();                          % stop the cursor (ginput)
                    else
                        % find the index of the x value closest to the mouse clicked
                        [c, x_index_mid] = min(abs(XValues-x));

                        % scale the sensitivity based on y (max y=496, lowest point on screen)
                        % if abs diff is large, sensitivity should be small
                        %max_diff = max(abs(linspace(1,496,496)-YValues(x_index_mid)));
                        max_diff = abs(YValues_RPE(x_index_mid) - YValues(x_index_mid));
                        diff = abs(y - YValues(x_index_mid));
                        if (diff>max_diff)
                            diff = max_diff;
                        end

                        % linear interpolation for sensitivity
                        sensitivity = floor((-max_sensitivity/max_diff)*diff + max_sensitivity + 10);

                        % log interpolation for sensitivity
                        %eqn = logspace(2,0,max_diff);
                        %sensitivity = floor(eqn(floor(diff)))

                        % create the x and y vectors based on n, sensitivity
                        ind = x_index_mid-sensitivity*n:sensitivity:x_index_mid+sensitivity*n;
                        for i = 1:length(ind)
                            % boundary conditions on endge of image
                            if ind(i)<1
                                ind(i)=1;
                            end
                            if ind(i)>1536
                                ind(i)=1536;
                            end
                            newx(i) = XValues(ind(i));
                            newy(i) = YValues(ind(i));
                        end

                        % Make the midpoint equal to the cursor
                        newy(ceil(length(ind)/2)) = y;  

                        % Find the spline between the n*2+1 points, plot it.
                        spline2 = spline(newx,newy);
                        %fnplt(spline2);

                        % replace the choroid value with this one
                        for j = ind(1):ind(3)
                            YValues(j) = ppval(spline2, XValues(j));
                        end

                        % remove original choroid line, plot the new one
                        [x,y];
                        h = findobj('Color','red');
                        handles.meta.Layers{im}.CHR.Y_old = h.XData;
                        handles.meta.Layers{im}.CHR.X_old = h.YData;
                        %plot(handles.meta.Layers{im}.CHR.Y_old, handles.meta.Layers{im}.CHR.X_old, 'g', 'LineWidth', 4);
                        delete(h);
                    
                        %delete(handles.CHR);
                        handles.CHR = plot(XValues, YValues, 'r', 'LineWidth', 2);
                        
                        % Save the previous CHR line to handles.CHR_old to
                        % allow for undo capabilities.  Save new adjusted
                        % CHR line as the current meta.Layer CHR line so
                        % future clicks reference this new adjusted CHR
                        % line.
                        handles.meta.Layers{im}.CHR.Y = XValues./handles.meta.resize(2);
                        handles.meta.Layers{im}.CHR.X = YValues;
                        handles.meta.Layers{im}.RPE.X = YValues_RPE;
                        
                        % Update handles structure.  You need to do this
                        % because you are inside Callback, so the handles
                        % you are updating in the lines above, are the
                        % "handles" given in the arguments of when this
                        % Callback was called.  You need to give these
                        % updated handles back to the "ChoroidVolumeGUI" script.  You
                        % can either (1) add an output to this function,
                        % have another function in the script read it and
                        % update the handes, or (2) update the handles
                        % directly from here with this super awesome
                        % function called guidata().  I chose the latter.
                        guidata(hObject, handles);

                    end

                    %drawnow();
                catch
                    disp('Window was closed =(');   % A way to not get an error when window is closed
                    return
                end
                [x,y,but]=ginput(0);
   
        end
        
        %output = editChoroidLine(hObject, eventdata, handles);
        %if (strcmp('stop_edit', output) == 1)  % if clicked outside the image area
        %    set(handles.edit_togglebutton, 'Value', 0); % set button to off
        %    edit_togglebutton_Callback(hObject, eventdata, handles) % and run this same function, so it goes to case 0, ie. button turned off
        %end
    case 0  % edit turned off, so disable edit panel objects
        %[x,y,but]=ginput(0); 
        %turnOffGInput();
        %exitFcn();
        set(handles.undo_pushbutton, 'enable', 'on');
        %set(handles.view_pushbutton, 'enable', 'on');
        set(handles.bottom_radiobutton, 'enable', 'on');
        set(handles.top_radiobutton, 'enable', 'on');
        set(handles.sensitivity_slider, 'enable', 'on');
        set(handles.sensitivity_text, 'enable', 'on');
        % update all information
        update_static_values(hObject, eventdata, handles);
        
end



% --- Executes on button press in undo_pushbutton.
function undo_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to undo_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

im  = str2double(get(handles.image_text,'String'));

% Find the current line, save its data, and delete it from the plot                        
h = findobj('Color','red');
TempX = h.XData;
TempY = h.YData;
delete(h);

% Plot the previous line, called _old
handles.CHR = plot(handles.meta.Layers{im}.CHR.Y_old, handles.meta.Layers{im}.CHR.X_old, 'r', 'LineWidth', 2);

% Make the previous line, that is now plotted, the current line
handles.meta.Layers{im}.CHR.Y = handles.meta.Layers{im}.CHR.Y_old./handles.meta.resize(2);
handles.meta.Layers{im}.CHR.X = handles.meta.Layers{im}.CHR.X_old;

% Make the _old line, the one that will be plotted if undo is pressed
% again, equal to the values of the line you first removed when undo was
% pressed.
handles.meta.Layers{im}.CHR.Y_old = TempX;
handles.meta.Layers{im}.CHR.X_old = TempY;

% update all the handles so other Callbacks know which line is current, and
% which is _old.
guidata(hObject, handles);

% update all information
%update_static_values(hObject, eventdata, handles);



% --- Executes on slider movement.
function sensitivity_slider_Callback(hObject, eventdata, handles)
% hObject    handle to sensitivity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
value = get(hObject, 'Value');
% round to nearest unit step, so sliding slider with mouse and clicking the arrows show the same number.
rounded = round(value/handles.unitstep)*handles.unitstep; % example: mouse slider to 17 -> 17/10=1.7 -> rounded to 2 -> 2*10 = 20.  Voila!
set(handles.sensitivity_text, 'String', rounded);


% --- Executes during object creation, after setting all properties.
function sensitivity_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sensitivity_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in bottom_radiobutton.
function bottom_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to bottom_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of bottom_radiobutton


% --- Executes on button press in top_radiobutton.
function top_radiobutton_Callback(hObject, eventdata, handles)
% hObject    handle to top_radiobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of top_radiobutton


% --- Executes on key press with focus on figure1 or any of its controls.
function figure1_WindowKeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
switch eventdata.Key
    case 'leftarrow'
        prev_pushbutton_Callback(hObject, eventdata, handles);
    case 'rightarrow'
        next_pushbutton_Callback(hObject, eventdata, handles);
end


% --- Executes on button press in view_togglebutton.
function view_togglebutton_Callback(hObject, eventdata, handles)
% hObject    handle to view_togglebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of view_togglebutton

value = get(hObject,'Value');   % 0=turned off, 1=turned on
switch value
    case 1  % view image turned on, so remove line                      
        h = findobj('Color','red');
        delete(h);
    case 0  % view image turned off, so add the current line back in
        im  = str2double(get(handles.image_text,'String'));
        % Plot the previous line, called _old
        handles.CHR = plot(handles.meta.Layers{im}.CHR.Y.*handles.meta.resize(2),handles.meta.Layers{im}.CHR.X,'r','LineWidth',2);
end


% --- Executes on button press in prevpose_pushbutton.
function prevpose_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to prevpose_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save all meta data of current pose before continuing
%setMetaX(hObject, eventdata, handles, handles.posenumber);

posenumber = handles.posenumber;
if (posenumber < 1)
    posenumber = 1;
elseif (posenumber == 1)
    posenumber = 1;
else
    posenumber = posenumber-1;
end
handles.posenumber = posenumber;
set(handles.currentpose_text,'String',num2str(handles.posenumber));
% Load the X and meta data of the current pose
[handles.X, handles.meta] = getMetaX(hObject, eventdata, handles, handles.posenumber);
% Load firt image, and lines
imgnumber = 1;
handles.imgnumber = imgnumber;
imshow(handles.X(:,:,1,imgnumber));
handles.RPE = plot(handles.meta.Layers{imgnumber}.RPE.Y.*handles.meta.resize(2),handles.meta.Layers{imgnumber}.RPE.X,'g','LineWidth',2);
handles.CHR = plot(handles.meta.Layers{imgnumber}.CHR.Y.*handles.meta.resize(2),handles.meta.Layers{imgnumber}.CHR.X,'r','LineWidth',2);
% update all information
set(handles.unedited_trapvolume_text, 'Max', 0);
update_static_values(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in nextpose_pushbutton.
function nextpose_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to nextpose_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Save all meta data of current pose before continuing
%setMetaX(hObject, eventdata, handles, handles.posenumber);

posenumber = handles.posenumber;
totalpose = length(handles.Poses);
if (posenumber > totalpose)
    posenumber = totalpose;
elseif (posenumber == totalpose)
    posenumber = totalpose;
else
    posenumber = posenumber+1;
end
handles.posenumber = posenumber;
set(handles.currentpose_text,'String',num2str(handles.posenumber));
% Load the X and meta data of the current pose, load first image
[handles.X, handles.meta] = getMetaX(hObject, eventdata, handles, handles.posenumber);
% load first image and lines
imgnumber = 1;
handles.imgnumber = imgnumber;
imshow(handles.X(:,:,1,imgnumber));
handles.RPE = plot(handles.meta.Layers{imgnumber}.RPE.Y.*handles.meta.resize(2),handles.meta.Layers{imgnumber}.RPE.X,'g','LineWidth',2);
handles.CHR = plot(handles.meta.Layers{imgnumber}.CHR.Y.*handles.meta.resize(2),handles.meta.Layers{imgnumber}.CHR.X,'r','LineWidth',2);
% update all information
set(handles.unedited_trapvolume_text, 'Max', 0);
update_static_values(hObject, eventdata, handles);
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in process_pushbutton.
function process_pushbutton_Callback(hObject, eventdata, handles)
% hObject    handle to process_pushbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% need to recalculate meta values added (diameter, origlayers, OCTvolumes,
% unedited volumes) before processing.
handles.meta.Diameter = get(handles.unedited_diameter_text, 'Max');

handles.meta.OCTVolume = get(handles.octvolume_text, 'String');

[Trapezoid, Simpson, SplineVolume] = calculateVolume(hObject, eventdata, handles);
handles.meta.TrapVolume = Trapezoid;
handles.meta.SimpsonVolume = Simpson;
handles.meta.SplineVolume = SplineVolume;

handles.meta.Unedited_TrapVolume = get(handles.unedited_trapvolume_text, 'Max');
handles.meta.Unedited_SimpsonVolume = get(handles.unedited_simpsonvolume_text, 'Max');
handles.meta.Unedited_SplineVolume = get(handles.unedited_splinevolume_text, 'Max');

handles.meta.Processed = 'Yes';

% Save all meta data of current pose before continuing
setMetaX(hObject, eventdata, handles, handles.posenumber);

% Change color (and blink) of processed so you know it saved
if strcmp(handles.meta.Processed,'Yes')
    set(handles.processed_text,'BackgroundColor','white');
    pause(.1);
    set(handles.processed_text,'BackgroundColor','green');
    pause(.1);
    set(handles.processed_text,'BackgroundColor','white');
    pause(.1);
    set(handles.processed_text,'BackgroundColor','green');
end

% update all information
update_static_values(hObject, eventdata, handles);

% Update handles structure
guidata(hObject, handles);
