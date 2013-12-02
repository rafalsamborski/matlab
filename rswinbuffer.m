function wBuff = rswinbuffer(sIn, fs, windowLengthMs, ...
    windowOverlappMs, wname)

if nargin == 3
    windowOverlappMs = 0;
end

if nargin == 4
    wname = @hamming;
end

% @WNAME can be any valid window function name, for example:
%
%   @bartlett       - Bartlett window.
%   @barthannwin    - Modified Bartlett-Hanning window. 
%   @blackman       - Blackman window.
%   @blackmanharris - Minimum 4-term Blackman-Harris window.
%   @bohmanwin      - Bohman window.
%   @chebwin        - Chebyshev window.
%   @flattopwin     - Flat Top window.
%   @gausswin       - Gaussian window.
%   @hamming        - Hamming window.
%   @hann           - Hann window.
%   @kaiser         - Kaiser window.
%   @nuttallwin     - Nuttall defined minimum 4-term Blackman-Harris window.
%   @parzenwin      - Parzen (de la Valle-Poussin) window.
%   @rectwin        - Rectangular window.
%   @taylorwin      - Taylor window.
%   @tukeywin       - Tukey window.
%   @triang         - Triangular window.

nSamplesInWindow    = windowLengthMs/1000*fs;
nSamplesOverlapp    = windowOverlappMs/1000*fs;
buff                = double(buffer(sIn, nSamplesInWindow, nSamplesOverlapp));
w                   = window(wname, nSamplesInWindow);
wBuff               = zeros(size(buff));

for colIdx = 1:size(wBuff, 2)
    wBuff(:, colIdx) = buff(:, colIdx).*w;
end
