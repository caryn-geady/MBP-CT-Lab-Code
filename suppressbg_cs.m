function finalROI = suppressbg_cs(data,threshold_bg)
   sz = size(data);
   x_len = sz(1);
   y_len = sz(2);
   for i = 1:x_len
      for j = 1:y_len
         if data(i,j) < threshold_bg
            data(i,j) = threshold_bg;
         end
      end
   end
   finalROI = data - threshold_bg;
end