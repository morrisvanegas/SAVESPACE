function [ output ] = editChoroidLine(hObject, eventdata, handles)
%editChoroidLine is a function that takes in the handles of the choroid
%guis, and is in charge of getting user input clicks, and editing the
%calculated segment line.
%   hObject    handle to edit_togglebutton (see GCBO)
%   eventdata  reserved - to be defined in a future version of MATLAB
%   handles    structure with handles and user data (see GUIDATA)

output = 'filler';
max_sensitivity = str2double(get(handles.sensitivity_text, 'String'));
%max_sensitivity = 100;%handles.max;
n=1;

im  = str2double(get(handles.image_text,'String'));
XValues = handles.meta.Layers{im}.CHR.Y*handles.meta.resize(2);
YValues = handles.meta.Layers{im}.CHR.X;
YValues_RPE = handles.meta.Layers{im}.RPE.X;

ind = [];
newx = [];
newy = [];
but = 1;

while(get(hObject,'Value')==1)  % While edit button is active
    try
        [x,y,but]=ginput(1);        % Start the cursor for user input
        
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
            sensitivity = floor((-max_sensitivity/max_diff)*diff + max_sensitivity + 1);

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
            delete(h);
            delete(handles.CHR);
            handles.CHR = plot(XValues, YValues, 'r', 'LineWidth', 2);
            
        end
        
        %drawnow();
    catch
        disp('Window was closed =(');   % A way to not get an error when window is closed
        return
    end
end


end

