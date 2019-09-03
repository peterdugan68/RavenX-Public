function [pcm] = earsread2018(fname, blk)
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

intsize = 16;

[~,~,endian] = computer;

try
    if nargin == 2
        numFrames = blk;  %return the block requested
    else
        numFrames = Inf;
    end
    
    % read raw uint16 data
    [pcmUINT16] = ears.earsreadUINT16(fname,numFrames);

    if strcmp(endian,'L')
        pcm = bitshift(pcmUINT16,8) + bitshift(pcmUINT16, -8);
    end
    
    
catch ME
    if strcmp(ME.identifier, 'MATLAB:badsubscript')
        pcm = [];  % cannot gaurentee the data
        warning('earsread2018 %s', ME.identifier);
    else
        rethrow(ME);
    end
end

normfac = 1/1000;
pcm = typecast(pcm(:), 'int16');
pcm = reshape(pcm, [1, numel(pcm)]);

pcm = bsxfun(@times, double(pcm), normfac);   % scale result

end

