% Author: Peter Vieting

function [v] = MassActionSto(x,m,Pre,MAK)
%MASSACTIONENABLING Transition function evaluation according to mass-action
%kinetics extended by a check whether the transition is enabled
%(for stochastic transitions)
%   The function evaluates the transition function according to the
%   mass-action kinetics. Two modes are available: classic mass-action
%   kinetics and simplified kinetics (default), where the weights in the
%   exponents are neglected.
%
%   Inputs:
%       x       T x 1 double            Transition rates
%       m       P x 1 double            Markings of all places
%       Pre     P x T integer/double    Input incidence matrix
%       MAK     'simplified'/'classic'  Mass-Action Kinetics specification

P   = numel(m);
T   = numel(x);
Pre_enabling = Pre; % Used for enabling check

if T==0
    v   = [];
    return
end

if nargin == 3; MAK = 'simplified'; end
switch MAK
    case 'simplified'
        Pre = double(Pre>0);
    case 'classic'
    otherwise
        error('Unknown specification of kinetics');
end

if ~iscolumn(x) || ~iscolumn(m) || ~isequal(size(Pre),[P T])
    error('Wrong input dimensions');
end

v   = x.*prod(repmat(m,1,T).^Pre).';

v   = v.*prod(repmat(m,1,T)>=Pre_enabling).'.*logical(sum(Pre_enabling>0)).';
end

