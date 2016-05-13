%  image_folder = 'Z:\Blog\5_3_14'; %  Enter name of folder from which you want to upload pictures with full path
image_folder ='D:\Image for media format\New folder';
filenames = dir(fullfile(image_folder, '*.jpg'));  % read all images with specified extention, its jpg in our case
 total_images = numel(filenames);    % count total number of photos present in that folder
 Matix= zeros(total_images);
%  Matrix=Matrix'; 
 for n = 1:total_images
  full_name= fullfile(image_folder, filenames(n).name);         % it will specify images names with full path and extension
%   our_images = imread(full_name);                 % Read images  
%   figure (n)                           % used tat index n so old figures are not over written by new new figures
%   imshow(our_images)                  % Show all images
%    Matix = filenames(n).name;

%  xlswrite('D:\aa.xls',full_name,'Sheet1',Mat(n));
% Matrix = filenames(1).name(n);
Matrix = {filenames.name};
 end
 Matrix=Matrix'; 
   xlswrite('a.xlsx',Matrix);