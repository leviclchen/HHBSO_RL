%STARTUP MATLAB startup file of the HHBSO-RL / interval type-2 fuzzy toolbox.
%
%   MATLAB executes startup.m automatically when it starts in this folder (or
%   when this folder is on the user path). The file puts src/ and data/ on the
%   MATLAB path and switches the figure style to docked windows.

rootDir = fileparts(mfilename('fullpath'));
if ~isempty(rootDir)
    addpath(genpath(fullfile(rootDir, 'src')));
    addpath(fullfile(rootDir, 'data'));
    addpath(fullfile(rootDir, 'data', 'instances'));
end

set(0, 'DefaultFigureWindowStyle', 'docked');
