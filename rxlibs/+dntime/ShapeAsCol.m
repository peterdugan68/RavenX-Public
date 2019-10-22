function A = ShapeAsCol(A);
% 
%
%  Usage:
%   A = ShapeAsCol(A)  
%
%  Inputs:
%      A - input vector, must be [1xN] or [Nx1], otherwise empty result is 
%          returned.  
%  
%  Outputs:
%      A - output vector, shaped as a column, empty if min dimension is 
%          greater than 1. 
%
%  Description:
%      ASE_Utils_ShapeAsCol ensures that input vector A is in col format.
%      If min dimension is greater than 1, then an empty result is
%      returned.
%

% History
%   PDugan       December 2009       Initial
%   pjd78        Oct 2010            Initial Triton         

A = utils.ShapeAsRow(A)';