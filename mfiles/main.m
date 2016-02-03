%% open/detect layers

Path_xml = ['XMLOutput/POS_1112_pose1'];    % no "/" means local reference
File_xml = 'C81FAE90.xml';
Path_xml = uigetdir('', 'Pick the folder where xml and tif files are located');
File_xml = uigetfile(strcat(Path_xml,'/*.xml'), 'Choose the xml file');
detect = 2;
[X,meta]=read_data_OCTtool([Path_xml '/'], File_xml, detect);
meta.OriginalLayers = meta.Layers;
im = 13;    % Which image number you want.
figure
imshow(X(:,:,1,im))
% X dimensions are (496, 2245, 1, 25) 
% X dimensions are (height of image, width, 1, 1-25)

hold on

%plot(meta.Layers{im}.ISOS.Y.*meta.resize(2),meta.Layers{im}.ISOS.X,'y','LineWidth',2)
plot(meta.Layers{im}.RPE.Y.*meta.resize(2),meta.Layers{im}.RPE.X,'g','LineWidth',2)
plot(meta.Layers{im}.ILM.Y.*meta.resize(2),meta.Layers{im}.ILM.X,'b','LineWidth',2)
h = plot(meta.Layers{im}.CHR.Y.*meta.resize(2),meta.Layers{im}.CHR.X,'r','LineWidth',2);


%% draw stuff!
but=1;xv=[];yv=[]; 
sensitivity = 1;
max_sensitivity = 100;
n = 1;
XValues = meta.Layers{im}.CHR.Y*meta.resize(2);
YValues = meta.Layers{im}.CHR.X;
YValues_RPE = meta.Layers{im}.RPE.X;
%plot(XValues, YValues, 'b');

ind = [];
newx = [];
newy = [];

while ((but==1)) 
    [x,y,but]=ginput(1); 
    if but==1 
        %xv=[xv x];yv=[yv y];    % a list of past buttons
        %plot(x,y,'*')   % plot an asterisk where you clicked
        
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
        delete(h);
        h = plot(XValues, YValues, 'r', 'LineWidth', 2);
        meta.Layers{im}.CHR.X = YValues;
        

    end 
end