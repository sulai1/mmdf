function [frames, descriptors] = opencv2vlfeat(f,d)
    pt =  {f(:).pt};
      nrFrames = numel(pt);
      x = zeros(1,nrFrames);
      y = zeros(1,nrFrames);
      r = zeros(1,nrFrames);
      a = zeros(1,nrFrames);
      for i=1:(nrFrames)
         p = pt{i} ;
         x(i) = double(p(1));
         y(i) = double(p(2));
         r(i) = double(f(i).size);
         a(i) = double(f(i).angle);
      end
            
      frames = [x;y;r;a];
      descriptors = uint8(transpose(d));
end

