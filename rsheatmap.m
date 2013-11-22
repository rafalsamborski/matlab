function figureHandle = rsheatmap(colorData, xTickLabels, yTickLabels, ...
    varargin)
%   RSHEATMAP(colorData, xLabels, yLabels)
%   RSHEATMAP(colorData, xLabels, yLabels, textData)
%   RSHEATMAP(colorData, xLabels, yLabels, textData)
%   RSHEATMAP(colorData, xLabels, yLabels, 'formatSpec', '%d', ...
%       'clims', [-5 23], 'colorbarOn', false, 'colorbarLabel', ...
%       'Magnitude', 'breakCScale', 0)
%
%   Inputs:
%       colorData       - NxM matrix containing data to be mapped into heatmap
%       xTickLabels     - labels for horizontal axis of heatmap (it can be
%                           both cell of strings or double array)
%       yTickLabels     - labels for vertical axis of heatmap (it can be
%                           both cell of strings or double array)
%
%   Optional inputs:
%       textData        - NxM matrix containing labels for each field of
%                           colorData (no text data is default)
%   Param-value inputs:
%       'formatSpec'    - specifies format for textData ('%f' is default)
%       'clims'         - sets the axes CLim property to the value passed
%                           ('auto' is default)
%       'colorbarOn'    - 'false' to disable colorbar ('true' is default)
%       'colorbarLabel'
%       'breakCScale'   -

p = inputParser;
% add required inputs
p.addRequired('colorData',                  @isnumeric);
p.addRequired('xTickLabels',                @(x) iscellstr(x) || isnumeric(x));
p.addRequired('yTickLabels',                @(x) iscellstr(x) || isnumeric(x));
% add optional inputs
p.addOptional('textData',           [],     @isnumeric);
% add paramValue inputs
p.addParamValue('formatSpec',       '%f',   @isstr);
p.addParamValue('clims',            'auto', @(x) isequal(x, 'auto') || ...
    (isnumeric(x) && length(x) == 2));
p.addParamValue('colorbarOn',       true,   @islogical);
p.addParamValue('colorbarLabel',    '',     @isstr);
p.addParamValue('breakCScale',      [],     @isnumeric);
parse(p, colorData, xTickLabels, yTickLabels, varargin{:});

colorData                                                                   = p.Results.colorData;
xTickLabels                                                                 = p.Results.xTickLabels;
yTickLabels                                                                 = p.Results.yTickLabels;
textData                                                                    = p.Results.textData;
formatSpec                                                                  = p.Results.formatSpec;
clims                                                                       = p.Results.clims;
colorbarOn                                                                  = p.Results.colorbarOn;
colorbarLabel                                                               = p.Results.colorbarLabel;
breakCScale                                                                 = p.Results.breakCScale;

[nRows, nCols]  = size(colorData);
figureHandle    = imagesc(colorData);

if ~isequal(clims, 'auto')
    caxis(clims);
end

set(gca,'XTick', 1:nCols);
if iscellstr(xTickLabels)
    set(gca,'XTickLabel', xTickLabels);
else
    set(gca,'XTickLabel', arrayfun(@num2str, xTickLabels, 'UniformOutput', false));
end

set(gca,'YTick', 1:nRows);
if iscellstr(xTickLabels)
    set(gca,'YTickLabel', yTickLabels);
else
    set(gca,'YTickLabel', arrayfun(@num2str, yTickLabels, 'UniformOutput', false));
end

if colorbarOn
    colorBarHandle = colorbar;
    ylabel(colorBarHandle, colorbarLabel, 'Interpreter', 'none');
end

hmCLim      = get(gca, 'CLim');
cRange      = diff(hmCLim);
if ~isempty(breakCScale)
    cMapN       = 254;
    lNegSide    = abs(round(min([hmCLim(1)-breakCScale, 0])));
    negSideN    = ceil(lNegSide/cRange*cMapN);
    blackLim    = [-inf inf];
    colormap([winter(negSideN); flipud(autumn(cMapN-negSideN))]);
else
    blackLim    = [hmCLim(1) + 0.20*cRange, hmCLim(2) - 0.10*cRange];
end

if ~isempty(textData)
    for rowIdx = 1:nRows
        for colIdx = 1:nCols
            if isInRange(colorData(rowIdx, colIdx), blackLim(1), blackLim(2))
                textColor = 'black';
            else
                textColor = 'white';
            end
            text(colIdx, rowIdx, num2str(textData(rowIdx, colIdx), formatSpec), ...
                'Color', textColor);
        end
    end
end

