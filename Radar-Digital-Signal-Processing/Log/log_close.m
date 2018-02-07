function [ output_args ] = log_close( log_file )
%LOG_CLOSE Closes the log file
%   This can just as easily be performed in the script; it's just made a
%   function for the sake of completeness.

if fclose(log_file) == -1
    fprintf('Error occurred when closing the log file...\n')
end

end

