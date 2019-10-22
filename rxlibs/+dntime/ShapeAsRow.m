function A = ShapeAsRow(A);
% 
%
%  Usage:
%   A = ShapeAsRow(A)  
%
%  Inputs:
%      A - input vector, must be [1xN] or [Nx1], otherwise empty result is 
%          returned.  
%  
%  Outputs:
%      A - output vector, shaped as a row, empty if min dimension is 
%          greater than 1. 
%
%  Description:
%      ASE_Utils_ShapeAsRow ensures that input vector A is in row format.
%      If min dimension is greater than 1, then an empty result is
%      returned.
%


% History
%   PDugan       December 2009       Initial 
%   pjd78        Oct 2010            Initial Triton       


[r,c] = size(A);

if (r ~= 1) && (c ~= 1)
   
    A = [];
    
    return;
    
elseif c < r
    
    A = A';
       
end