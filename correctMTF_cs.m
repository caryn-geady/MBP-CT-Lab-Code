function correctedMTF = correctMTF_cs(data,freq_y,freq_z)
   sz = size(data);
   y_len = sz(1);
   z_len = sz(2);
   d = 0.035; %in mm
   newdata = zeros(y_len,z_len);
   for i = 1:y_len
       for j = 1:z_len
           r = sqrt((freq_y*(i-21))^2 + (freq_z*(j-21))^2);
           newdata(i,j) = data(i,j)/((2*besselj(1,pi*d*r))/(pi*d*r));
       end
   end
   %newdata(21,21) = max(newdata(:));
   newdata(21,21) = data(21,21);
   correctedMTF = newdata;
end