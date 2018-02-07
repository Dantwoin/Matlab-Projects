function [ ] = log_write( scan_data, log_file )
%LOG_WRITE Writes scan data to log file

fprintf(log_file,'%d,',scan_data);
fprintf(log_file,'\n');

end

