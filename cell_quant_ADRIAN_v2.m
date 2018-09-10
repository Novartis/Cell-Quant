%Copyright 2018 Novartis Institutes for BioMedical Research Inc. Licensed
%under the Apache License, Version 2.0 (the "License"); you may not use
%this file except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0. Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.%

clearvars
close all
clc

if exist(fullfile(pwd,'temp_data.mat'),'file')
    load('temp_data.mat')
    clearvars -except output_data ind0 fig1 path_nm file_list rand_ind
    ind0_start = ind0+1;
else
    ind0_start = 1;
    path_nm = uigetdir(pwd,'Choose folder containing images:');
    file_list = dir(fullfile(path_nm,'*.ti*'));
     
    output_data = cell(size(file_list,2),3);

    output_data{1,1} = 'Filename';                                                  % Format output
    output_data{1,2} = 'Cell Count';

    
    rand_ind    = randperm(size(file_list,1));
end
fig1 = figure('units','normalized','outerposition',[0.0 0.04 1.0 0.96],'MenuBar','none','Toolbar','none','Visible','off'); 

for ind0 = ind0_start:size(file_list,1)
    rand        = rand_ind(ind0);
    filename	= file_list(rand).name;
    data        = imread(fullfile(path_nm,filename));

    red_layer	= imadjust(data(:,:,2));

    background	= imopen(red_layer,strel('disk',15));
    red_adj     = red_layer - background;
    

    
    thresh_mask	= im2bw(red_adj,48/255);                                    % signal intensity, 5x=75 %
    mask_trim   = bwareaopen(thresh_mask,800);                              % large exclusion size, 5x=500 %       
    thresh_mask = bwareaopen(thresh_mask,200);                               % small exclusion size, 5x=50 %          
    thresh_mask = thresh_mask .* ~mask_trim;
    thresh_mask	= uint8(thresh_mask);
    
    red_adj     = red_layer .* thresh_mask;

    disp_data(:,:,1)  = red_adj.*225;
    disp_data(:,:,2)  = red_layer .* uint8(~red_adj);
    disp_data(:,:,3)  = red_adj.*225;
    disp_data = uint8(disp_data);
    
    set(fig1,'Visible','on')

    imshow(disp_data)
    title(sprintf('Crop Fluorescence: Image %u of %u',ind0,size(file_list,1)))
    
    h0 = msgbox('Crop miscellaneous fluorescense.');
    uiwait(h0)
    click = 0;
    
    while ~click
        h1 = imfreehand;
        crop_mask = ~createMask(h1);
        thresh_mask  = thresh_mask .* uint8(crop_mask);
        
        red_adj    = uint8(red_adj.*thresh_mask);
        
        disp_data(:,:,1)  = uint8(red_adj.*255);
        disp_data(:,:,2)  = red_layer .* uint8(~red_adj);
        disp_data(:,:,3)  = uint8(red_adj.*255);
        
        imshow(disp_data)
        title(sprintf('Crop Fluorescence: Image %u of %u',ind0,size(file_list,1)))
        click = waitforbuttonpress;
    end
    
    h0 = msgbox('Click on missed cells to add them to the analysis');
    uiwait(h0)
    click = 0;
    while ~click
        imshow(disp_data)
        title('Click to add cells')
            
        [x,y]   = ginput(1);
        x       = uint16(x);
        y       = uint16(y);
        
        red_adj(y-10:y+10,x-10:x+10)    = 1;                            % 5x images = 5 %
        disp_data(:,:,1)            = uint8(red_adj.*255);
        disp_data(:,:,2)            = red_layer .* uint8(~red_adj);
        disp_data(:,:,3)            = uint8(red_adj.*255);
        imshow(disp_data)

        title('Click to add cells')
        click = waitforbuttonpress;
    end
    red_adj     = imfill(red_adj.*255,'holes');
    red_adj     = bwareaopen(red_adj, 5);
    
    cc_cells    = bwconncomp(red_adj,8);
    cell_num    = cc_cells.NumObjects;
    
    output_data{ind0+1,1} = filename;
    output_data{ind0+1,2} = cell_num;
    save(fullfile(pwd,'temp_data.mat'))
    clearvars -except output_data ind0 fig1 path_nm file_list rand_ind
end
close(fig1)
delete(fullfile(pwd,'temp_data.mat'))
OutputFile_XLSX = fullfile(path_nm,strcat('Output_Data_', datestr(now,'mmddyy_HHMM'), '.xlsx'));
xlswrite(OutputFile_XLSX,output_data)
fprintf('Excel data saved to:\n%s\n',OutputFile_XLSX)
winopen(OutputFile_XLSX)