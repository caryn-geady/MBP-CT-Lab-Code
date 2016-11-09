function correctedMTF = correctMTF(data,freq_pix)
   sz = size(data);
   x_len = sz(1);
   y_len = sz(2);
   d = 0.035; %in mm
   newdata = zeros(x_len,y_len);
   for i = 1:x_len
       for j = 1:y_len
           r = sqrt((freq_pix*(i-21))^2 + (freq_pix*(j-21))^2);
           newdata(i,j) = data(i,j)/((2*besselj(1,pi*d*r))/(pi*d*r));
       end
   end
   disp(data(21,21))
   newdata(21,21) = data(21:21);
   correctedMTF = newdata;
end