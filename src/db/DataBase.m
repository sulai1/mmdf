classdef DataBase < handle
    %Database stores images and compressed versions and allows to access them through indices.
    %   images and compressed versions are stored in the res folder but
    %   stored as bmp for easy access. The database is also responible for
    %   retrieving the image and its compression level.
    %   The acces to the images happens only through indices.
    %
    %   If an Image is added the file is stored into the res folder. Now it
    %   generates compressed images with differest sizes and add them to
    %   res. The initial size is determined by the smallest filesize the
    %   compression with maximum quality generates. The amount off 
    %   compression levels is specified as a constant.In the next step the
    %   compressed images are converted back to bmp, so we can work with
    %   them inside Matlab
    %   Currently supported compressions are jpg,jp2 and jxr
    
    properties(Access = private)
        QualityLevels = 5;
        Folder;
        List;
        Index = 1;
    end
    
    methods
        
        %create a new data base in the given folder with the given quality
        %levels.
        function DB = DataBase(Folder,QualityLevels)
            DB.Folder = Folder;
            DB.QualityLevels = QualityLevels;
            DB.List = cell(2);
            save([Folder,'/db'],'QualityLevels');
        end
        
        function add(DB, element)
            %% create folder or overrite if exists
            folder =  int2str(DB.Index);
            if(~isempty(dir([DB.Folder,'/',folder])))
               rmdir([DB.Folder,'/',folder],'s'); 
            end
            mkdir(DB.Folder,int2str(DB.Index));
            %% add element to database folder
            imagename =  char([DB.Folder,'/',folder,'/',folder]);
            name = [imagename,'.bmp'];
            size=intmax;
            imwrite(element.Data,name);
            
            %% calculate initial size by choosing the smallest size with full quality
            JPG = 'tmp.jpg';
            JP2 = 'tmp.jp2';
            JXR = 'tmp.jxr';
            
            Converter.convert(name, JPG ,1);
            d = dir(JPG);
            size = min(d(1).bytes,size);
            
            Converter.convert(name, JP2,1);
            d = dir(JP2);
            size = min(d(1).bytes,size);
            
            Converter.convert(name, JXR,1);
            d = dir(JXR);
            size = min(d(1).bytes,size);
            
            %% add entry to data base
            DB.List{DB.Index} = element;
            
            
            %% add different compression qualities by halfing the size each  time
            for i=0:DB.QualityLevels
                newname = [imagename,'_',int2str(i),'jpg',Converter.BMP];
                Converter.convert2size(name,JPG, size);
                Converter.convert(JPG,newname);
                
                newname = [imagename,'_',int2str(i),'jp2',Converter.BMP];
                Converter.convert2size(name,JP2, size);
                Converter.convert(JP2,newname);
                
                newname = [imagename,'_',int2str(i),'jxr',Converter.BMP];
                Converter.convert2size(name,JXR, size);
                Converter.convert(JXR,newname);
                
                size = size/2;
            end
            delete(JPG);
            delete(JP2);
            delete(JXR);
            %% add element to the list
            l = length(DB.List);
            if(DB.Index>l)
               extent{DB.Index} = Image;
               DB.List = [DB.List, extent];
            end
                
        end
            
        % get the reference image at the given index
        function E = getReferenceImage(DB, index)
            E = DB.List(index);
        end
        
        function IL = getAllLevels(DB,index)
            id = int2str(index);
            IL = cell(3,DB.QualityLevels);
            for i=1:DB.QualityLevels
                IL{1,i} = Image.read([DB.Folder,'/',id,'/',id,'_',int2str(i),'jpg',Converter.BMP]);
                IL{2,i} = Image.read([DB.Folder,'/',id,'/',id,'_',int2str(i),'jpg',Converter.BMP]);
                IL{3,i} = Image.read([DB.Folder,'/',id,'/',id,'_',int2str(i),'jpg',Converter.BMP]);
            end
             
        end
        
        % get the compressed image at the given index with the given format
        % and quality index
        function I = getFormatedImage(DB, index, qualindex, format)
           name = [DB.Folder,int2str(index),'_',int2str(qualindex),'.',format] ;
           I = Image.read(name);
        end
           
        % set the size of the list
        function setSize(DB, size)
            DB.List = cell(size);
            DB.List{size} = Image; 
        end
        
        %get the size of the list
        function S = getSize(DB)
            S = DB.Index-1;
        end
        
        % display the list
        function disp(DB)
           disp(DB.List) 
        end
        
        %clear the  list
        function clear(DB)
           DB.List = cell(2);
           DB.Index = 1;
        end
    end
    
    methods (Static)
        %init the path
        function init()
            addpath extraction;
        end
        
        function DB = load(Folder)
            %% laod data base fields and generate db
           	l = load([Folder,'/db']);
            DB = DataBase(Folder, l.QualityLevels);
            
            %% get the folder
            d = dir(Folder);
            dirFlags = [d.isdir];
            subFolders = d(dirFlags);
            
            DB.Index = length(subFolders)-2; %don't count '.' and '..'
            DB.List = cell(DB.Index);
            disp(subFolders)
            %%simply load the files by index
            for i=3:length(subFolders) % skip '.' and '..'
                img = [Folder,'/',int2str(i-2),'/',int2str(i-2),'.bmp'];
                disp(img);
                DB.List{i-2} = Image.read(img);
            end
        end
    end
    
end

