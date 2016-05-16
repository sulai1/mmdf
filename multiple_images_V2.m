%  Enter name of folder from which you want to upload pictures with full path

image_folder ='D:\Image for media format\New folder';
% read all images with specified extention, its jpg in our case

filenames = dir(fullfile(image_folder, '*.jpg'));
% count total number of photos present in that folder

total_images = numel(filenames);

Matix= zeros(total_images);
%  Matrix=Matrix';

for n = 1:total_images
    % it will specify images names with full path and extension
    full_name= fullfile(image_folder, filenames(n).name);
    
    Matrix = {filenames.name};
end

Matrix=Matrix';

xlswrite('b.xlsx',Matrix);



