function opts = argparse( struct, varargin )
%ARGPARSE Summary of this function goes here
%   Detailed explanation goes here
    opts = struct;
    names = fieldnames(struct);
    if ~isempty(varargin{1})
        for i=1:2:length(varargin{1})
            for j=1:numel(names)
                name = varargin{1}{i};
                val =  varargin{1}{i+1};
                n = names{j};
                if strcmp(names(j), name)
                    opts = setfield(opts,n,val);
                end
            end
        end
    end
end

