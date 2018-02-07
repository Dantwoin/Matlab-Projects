function [ scn,log_end ] = get_scans(srl,param,log_file)
%GET_SCANS Returns scan data for graphing and detection functions
%   Checks paramaters to see whether scan data is coming from a log file or
%   from real-time radar data. It also calls log_write() if necessary.

switch param.data_source
    case 0 
        scn = create_scans(srl,param);
        if param.save_log
            log_write(scn,log_file);
        end
        log_end = 0;
    case 1
        [scn,log_end] = log_read(log_file,param);
        pause(.02);
end

