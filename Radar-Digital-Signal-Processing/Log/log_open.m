function [ log_file ] = log_open( param )
%LOG_OPEN Opens the the log file

switch param.data_source
    case 0
        log_file = fopen(param.log_filename,'w');
    case 1
        log_file = fopen(param.log_filename,'r');
if log_file == -1
    fprintf('Error: Could not open log file\n')
end

end

