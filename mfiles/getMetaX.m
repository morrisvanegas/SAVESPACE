function [ X, meta ] = getMetaX( hObject, eventdata, handles, i )
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

meta_data = strcat(handles.Path_poses, '/', handles.Poses(i).name, '/', handles.Poses(i).name, '_meta.mat');
load(meta_data);
X_data    = strcat(handles.Path_poses, '/', handles.Poses(i).name, '/', handles.Poses(i).name, '_X.mat');
load(X_data);

end

