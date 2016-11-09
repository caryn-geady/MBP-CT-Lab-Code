function croppedROI = cropROI_cs(data, cropsize, threshold)
   num = 0;
   z_centre = 0;
   y_centre = 0;
   sz = size(data);
   z_size = sz(3);
   y_size = sz(1);
   %disp([z_size y_size])
   for i = 1:z_size
       for j = 1:y_size
           if data(j,:,i) > threshold
               num = num + 1;
               z_centre = z_centre + i;
               y_centre = y_centre + j;
           else continue
           end
       end
   end
   z_centre1 = z_centre/num;
   y_centre1 = y_centre/num;
   disp([z_centre1 y_centre1])
   rad = cropsize/2;
   z_min = floor(z_centre1 - rad);
   z_max = floor(z_centre1 + rad);
   y_min = floor(y_centre1 - rad);
   y_max = floor(y_centre1 + rad);
   %disp([z_min z_max y_min y_max])
   croppedROI = squeeze(data(y_min:y_max,:,z_min:z_max));
end