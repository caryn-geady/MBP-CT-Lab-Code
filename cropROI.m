function croppedROI = cropROI(data, cropsize, threshold)
   num = 0;
   x_centre = 0;
   y_centre = 0;
   sz = size(data);
   x_size = sz(1);
   y_size = sz(2);
   for i = 1:x_size
       for j = 1:y_size
           if data(i,j) > threshold
               num = num + 1;
               x_centre = x_centre + i;
               y_centre = y_centre + j;
           else continue
           end
       end
   end
   x_centre1 = floor(x_centre/num);
   y_centre1 = floor(y_centre/num);
   disp([x_centre1,y_centre1])
   rad = cropsize/2;
   x_min = x_centre1 - rad;
   x_max = x_centre1 + rad;
   y_min = y_centre1 - rad;
   y_max = y_centre1 + rad;
   croppedROI = data(x_min:x_max,y_min:y_max);
end