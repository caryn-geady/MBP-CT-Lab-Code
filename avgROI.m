function procROI = avgROI(data,sec_start,sec_end,cropsize,threshold)
   sec_len = sec_end - sec_start + 1;
   sum = 0;
   data = data(200:350,200:350,:);
   for i = sec_start:sec_end
      sum = sum + cropROI(data(:,:,i),cropsize,threshold);
   end
   procROI = sum/sec_len;
end