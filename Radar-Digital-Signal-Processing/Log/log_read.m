function [ scn log_end ] = log_read( log_file, param )
%LOG_READ Reads log files

scn = fscanf(log_file,'%d,',param.Nbin);
scn = scn';
log_end = feof(log_file);

end

