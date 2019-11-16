function [s_data, format1] = save_text_file_data(x, filename, parent_filename)
%This function is used for saving text files

fid = fopen(filename,'w');
fclose(fid);
data_for_save=x;
s_data=size(x);
format1='\n';
format2='%e\t';

for dd1=1:s_data(2)
format1=[format2 format1];
end

fid = fopen(filename,'a');
fprintf(fid,'%s\n',parent_filename);
fprintf(fid,'%d\t%d\n',s_data);
fprintf(fid,'%s\n',format1);
fclose(fid);

for dd1=1:s_data(1)
    fid = fopen(filename,'a');
    fprintf(fid,format1,data_for_save(dd1,:));
    fclose(fid);
end
end
