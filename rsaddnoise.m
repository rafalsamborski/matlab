function sOut = rsaddnoise(sIn, fs, sNR, noise, noiseFs)
margin                  = 1; % in seconds
normalizationMethod     = 'RMS'; % 'max'/'RMS'

if nargin > 3
    noise               = resample(noise, fs, noiseFs);
    noise               = noise(margin*fs:end-margin*fs, 1);
else
    noise               = randn(size(sIn));
end

noiseStart              = randi(length(noise)-length(sIn));
noiseIn                 = noise(noiseStart:noiseStart+length(sIn)-1);

switch normalizationMethod
    case 'RMS'
        sNorm                   = sIn/sqrt(sum(sIn.^2));
        noiseNorm               = noiseIn/sqrt(sum(noiseIn.^2));
    case 'max'
        sNorm                   = sIn/max(abs(sIn));
        noiseNorm               = noiseIn/max(abs(noiseIn));
end

% noiseFactor             = sqrt((sum(sNorm.^2)/sum(noiseIn.^2))*10^(-0.1*sNR));

noiseFactor             = 10^((rspowerdb(sNorm)-rspowerdb(noiseNorm)-sNR)/20);

noiseNorm               = noiseFactor*noiseIn;
sOut                    = sNorm+noiseNorm;

switch normalizationMethod
    case 'RMS'
        sOut                    = sOut/sqrt(sum(sOut.^2));
    case 'max'
        sOut                    = sOut/max(abs(sOut));
end
