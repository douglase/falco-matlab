% Copyright 2018, by the California Institute of Technology. ALL RIGHTS
% RESERVED. United States Government Sponsorship acknowledged. Any
% commercial use must be negotiated with the Office of Technology Transfer
% at the California Institute of Technology.
% -------------------------------------------------------------------------
%
function [ OUT ] = hexSegMirror_getSupport( hexMirror_struct )
%hexSegMirror_getSupport Returns the support of the pupil function defined
%by a hexagonally segmented mirror 
%   Input: hexMirror_struct - Structure with the following variables 
%   apDia - flat to flat aperture diameter (samples)
%   gapWidth - width of the gap between segments (samples)
%   numRings - number of rings in the segmented mirror (samples)
%   N - size of NxN computational grid 

apDia = hexMirror_struct.apDia; % flat to flat aperture diameter (samples)
gapWidth = hexMirror_struct.gapWidth; % samples
numRings = hexMirror_struct.numRings;% Number of rings in hexagonally segmented mirror 
N = hexMirror_struct.Npad;

if(isfield(hexMirror_struct,'missingSegments'))
    missingSegments = hexMirror_struct.missingSegments;
else
    missingSegments = ones(1,hexSegMirror_numSegments( numRings ));
end
    
OUT = zeros(N);

hexFlatDiam = (apDia-numRings*2*gapWidth)/(2*numRings+1);
hexSep = hexFlatDiam + gapWidth;

count = 1;
for ringNum = 0:numRings

    cenrow = ringNum*hexSep;
    cencol = 0;
    
    if(missingSegments(count)==1)
        [ OUT ] = hexSegMirror_addHexagon( cenrow,cencol, hexFlatDiam, OUT );
    end
    count = count + 1;
    
    for face = 1:6
        
        step_dir = pi/6*(2*face+5);
        steprow = hexSep*sin(step_dir);
        stepcol = hexSep*cos(step_dir);
        
        stepnum = 1;

        while(stepnum<=ringNum)
            cenrow = cenrow + steprow;
            cencol = cencol + stepcol;
            if(face==6 && stepnum==ringNum)
                %disp(['Finished ring ',num2str(ringNum)]);
            else
                if(missingSegments(count)==1)
                    [ OUT ] = hexSegMirror_addHexagon( cenrow,cencol, hexFlatDiam, OUT );
                end
                count = count + 1;
            end
            stepnum = stepnum + 1;
            
        end
    end
end


end

