function [pcmUINT16] = earsreadUINT16(fname,numFrames)
%function [pcm] = earsreadUNIT16(fname, blk)
%
%   Usage:
%       [pcm] = earsread(fname, blk)
%
%   input
%       fname - EARS file
%         blk - read block
%
%   output:
%       pcm - pcm data, range [-1..1]
%
% Copyright 2013-2019 Cornell Lab of Ornithology
%   PDugan, based on memmap FileSignal JZollweg and EARS sensor info

[~,~,endian] = computer;

switch(endian)
    case 'L'
        machineformat = 'ieee-le';
    case 'B'
        machineformat = 'ieee-be';
end

try
    
    if iscell(fname)
        fname = fname{1};
    end
    
    if numel(numFrames) > 1
        f1 = numFrames(1);
        f2 = numFrames(2);
    else
        f1 = 1;
        f2 = numFrames;
    end
    
    fd = fopen(fname, 'r', machineformat );
    if (fd < 0)
        fprintf('File not present: %s\n', fname);
        return
    end
    
    % pjd - one can dupe out the endian by reading as le, then using the
    % lines below to read the sounds directly, skipping header portions.
    % fseek(fd,12,'bof');
    % pcm = fread(fd, [250, Inf], '250*int16', 12, machineformat);  % read all data blocks, skip headers
    
    bin = uint16(fread(fd, [256, Inf], '256*uint16', 0, machineformat));  % read all data blocks, skip headers
    pcmUINT16 = bin(7:end,1:end);  % peel off only the data portion, leave the header
    pcmUINT16 = reshape(pcmUINT16, 1, []);
    if isinf(f2)
        pcmUINT16 = pcmUINT16(f1:end);
    else
        pcmUINT16 = pcmUINT16(f1:f2);
    end
    clear bin;
    
    
catch ME
    if strcmp(ME.identifier, 'MATLAB:badsubscript')
        pcm = [];  % cannot gaurentee the data
        warning('earsread2018 %s', ME.identifier);
    else
        rethrow(ME);
    end
end

fclose(fd);

end


