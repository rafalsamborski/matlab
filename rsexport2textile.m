function outChar = rsexport2textile(inputVar, varargin)
%CELL2TEXTILE Export cell/dataset/numeric array to textile format
% OUTCHAR = EXPORT2TEXTILE(INPUTVAR) exports INPUTVAR to textile table 
% format e.g. for redmine documentation
% OUTCHAR = EXPORT2TEXTILE(INPUTVAR, FALSE) disables header marks in first
% row. Header is enabled by default.
% 
% Example:
% >> a = {'Id', 'Name', 'Flag', 'Value'; 345, 'Foo', true, 1-i};
% >> export2textile(a, 1)
% 
% ans =
% 
% |_.Id |_.Name|_.Flag|_.Value|
% |  345|  Foo |  1   |  1-1i |

% headerOn provided or default?
if nargin == 1
  headerOn = true;
else
  headerOn = varargin{1};
end

% unify input variable to cell of chars
if isa(inputVar, 'numeric')
  inputCell = num2cell(inputVar);
elseif isa(inputVar, 'dataset')
  inputCell = dataset2cell(inputVar);
end
inputCell = cellfun(@if2str, inputCell, 'UniformOutput', false);

% get the size of input
nRows   = size(inputCell,1);
nCols   = size(inputCell,2);

% construct column separator depending on headerOn flag
if ~headerOn || nRows == 1
  colSep = repmat('|  ', nRows, 1);
else
  colSep = char('|_.', repmat('|  ', nRows-1, 1));
end

% initialize output
outChar = repmat('', nRows, 1);

% construct output char
for colIdx = 1:nCols
    outChar = [outChar colSep char(inputCell(:,colIdx)) repmat('  ', nRows, 1);]; %#ok<AGROW>
end

% add left most separator
outChar = [outChar repmat('|', nRows, 1)];

% additional function employed for input unification
function y = if2str(x)
if isnumeric(x) || islogical(x)
  y = num2str(x);
elseif isa(x, 'nominal')
  y = char(x);
else
  y = x;
end
