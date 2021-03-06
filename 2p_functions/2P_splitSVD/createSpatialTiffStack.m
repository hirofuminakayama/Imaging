function createSpatialTiffStack(name,varargin)
%save tif stack for manula segmentation
if numel(varargin)==0
    
    
    load(name)
    if exist('Uall','var')
        U=Uall; 
    end
    %Incase full path is given, only extract the file name
    [filepath,name,ext] = fileparts(name);
else
    if ischar(varargin{1})
        filepath=vararing{1};
        load(filepath)
        if exist('Uall','var')
            U=Uall;
        end
    else
        U=varargin{1};
    end
end

if size(U,1)==512^2
    img_size=512;
elseif size(U,1)==256^2
    img_size=256;
else
   error('wrong size of inputs. Need to have 256^2 or 512^2 pixels') 
end

img_stack=[];
for i=1:25
    img_stack(:,:,i)=imadjust(imgaussfilt(mat2gray(reshape(U(:,i),img_size,img_size))));
end
% name='JG1221_190516_field2_stim_00001_';
try
    direct = configPath();
    cd(direct.home_2p)
    cd('.\Segmentation\tiff_segmentation')
    save_tiffstack(img_stack,strcat(name,'_SpatialComponents_forSegmentation'))
    cd(direct.home_2p)
catch
    %Save in the pwd
    save_tiffstack(img_stack,strcat(name,'_SpatialComponents_forSegmentation'))
end
