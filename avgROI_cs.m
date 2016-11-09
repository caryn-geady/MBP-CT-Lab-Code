function procROI = avgROI_cs(data,sec_start,sec_end,cropsize,threshold)
   sec_len = sec_end - sec_start + 1;
   sum = 0;
   data1 = data(200:350,:,140:200);
   for i = sec_start:sec_end
      sum = sum + cropROI_cs(data1(:,i,:),cropsize,threshold);
   end
   %disp(size(sum))
   procROI = sum/sec_len;
end