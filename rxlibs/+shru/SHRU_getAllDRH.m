function [drhs]=SHRU_getAllDRH(fid)
% ------------------------------------------------------------------
%   SHRU_getAllDRH
%
%      Read all data record headers for a particular file
%
%  Remember:  File should be opened big endian for Shru
%               fid = fopen(filename,'rb','ieee-be');
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% subroutine: SHRU_getAllDRH.m  
% author: YT Lin
% date: 5/9/2012
% history: 2009 Aug version of this subroutine is a modification of 
%                                    SHRU's program in SW06
% notes: 
% (1) The subroutine is universal for all SHRU's with different numbers of
% channels. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

  fseek(fid,0,'bof');   %  go to beginning of file
  drhs = [];
  sav = 0;
    
  while 1,
      
    [drh,status] = shru.SHRU_getDRH(fid);
    if(status < 0),
        % fprintf('\t%d records found\n',sav); 
        return; 
    end
       
    if ~strcmp(drh.rhkey,'DATA')
          fprintf('Bad record found at #%d\n',sav);   % starts at #0
          return
    end

    % skip over data
    bytes_rec = drh.ch * drh.npts * 2;
    status = fseek(fid,bytes_rec,'cof');
    
    if (status < 0),
        % fprintf('\t%d records found\n',sav);  
        return; 
    end
    
    sav = sav + 1;
    drhs = [drhs; drh];
    
  end   

return