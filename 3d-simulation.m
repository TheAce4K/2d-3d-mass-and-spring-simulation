%% variabler
clear all
n=3;
N= (6*n+1);
masses = N^2;
springs = (N-1)^2;
K = 1;
kPart = K*(N-1);
massTot = 1;
massPart = massTot/masses;
originaLength = 1;
lengthPart = 1/(N-1);
alpha = 0.001;



%% skapa  bestämda punkter
[xPoints, yPoints] = meshgrid(0:1/(N-1):1,0:1/(N-1):1);
zPoints = zeros(N);
% firstFixedPoint är där den är 1/3
[~,firstFixedPoint] = find(xPoints == 1/3,1);
secondFixedPoint = firstFixedPoint*2-1;
zPoints(firstFixedPoint,firstFixedPoint) = 1;
zPoints(secondFixedPoint,secondFixedPoint) = 1;

%% fixpunktsiterera fram punkternas positioner
newXPoints = xPoints;
newYPoints = yPoints;
newZPoints = zPoints;
% fixpunkts iterera tills kraften är tillräkligt liten
forces = zeros(size(xPoints));
forceMax = 1;
while forceMax > 10^-6
    % gör fixpunktsiterationen för alla punkter förutom de redan bestämda
    % k = x l = y

    for k = 1:N
        for l = 1:N
            % längsta if sattsen någonsin som egentligen bara tar bort de
            % fixerade punkterna
           if ~(k ==firstFixedPoint && l== firstFixedPoint) && ~((k == secondFixedPoint) && (l == secondFixedPoint)) && ~(k==1 && l==1) && ~(k==1 && l==N) && ~(k==N && l==1) && ~(k==N && l==N) && ~(k==((N+1)/2) && l==1) && ~(k==((N+1)/2) && l==N) && ~(k==1 && l==((N+1)/2)) && ~(k==N && l==((N+1)/2))
                stretchedLength = @(xi,xj,yi,yj,zi,zj) sqrt((xj-xi)^2 + (yj-yi)^2 + (zj-zi)^2 );
                % följande if sattser gör så att man sätter kraften till 0
                % om det inte finns en massa åt det håller man försöker
                % räkna
                % i if sattserna räknar man ut kraften som kommer från det
                % hållet
                if ~(k == N)
                
                    stretchedLengthRight = stretchedLength(xPoints(l,k),xPoints(l,k+1),yPoints(l, k),yPoints(l,k+1),zPoints(l, k),zPoints(l,k+1));
                    
                    FxRight = kPart * (stretchedLengthRight-lengthPart)*( ( xPoints(l,k+1)-xPoints(l,k) ) / stretchedLengthRight);
                    FyRight = kPart * (stretchedLengthRight-lengthPart)*( ( yPoints(l,k+1)-yPoints(l,k) ) / stretchedLengthRight);
                    FzRight = kPart * (stretchedLengthRight-lengthPart)*( ( zPoints(l,k+1)-zPoints(l,k) ) / stretchedLengthRight);
                
                else
                    FxRight = 0;
                    FyRight = 0;
                    FzRight = 0;
                end
                if ~(k == 1)
                    stretchedLengthLeft = stretchedLength(xPoints(l,k),xPoints(l,k-1),yPoints(l,k),yPoints(l, k-1),zPoints(l,k),zPoints(l, k-1));
                    
                    FxLeft = kPart * (stretchedLengthLeft-lengthPart)*( ( xPoints(l,k-1)-xPoints(l,k) ) / stretchedLengthLeft);
                    FyLeft = kPart * (stretchedLengthLeft-lengthPart)*( ( yPoints(l,k-1)-yPoints(l,k) ) / stretchedLengthLeft);
                    FzLeft = kPart * (stretchedLengthLeft-lengthPart)*( ( zPoints(l,k-1)-zPoints(l,k) ) / stretchedLengthLeft);
                
                else
                    FxLeft = 0;
                    FyLeft = 0;
                    FzLeft = 0;
                end
                if ~(l==N)
                stretchedLengthUp = stretchedLength(xPoints(l,k),xPoints(l+1,k),yPoints(l,k),yPoints(l+1,k),zPoints(l,k),zPoints(l+1,k));
                
                FxUp = kPart * (stretchedLengthUp-lengthPart)*( ( xPoints(l+1,k)-xPoints(l,k) ) / stretchedLengthUp);
                FyUp = kPart * (stretchedLengthUp-lengthPart)*( ( yPoints(l+1,k)-yPoints(l,k) ) / stretchedLengthUp);
                FzUp = kPart * (stretchedLengthUp-lengthPart)*( ( zPoints(l+1,k)-zPoints(l,k) ) / stretchedLengthUp);
                else
                    FxUp = 0;
                    FyUp = 0;
                    FzUp = 0;
                end
                if ~(l==1)
                    stretchedLengthDown = stretchedLength(xPoints(l,k),xPoints(l-1,k),yPoints(l,k),yPoints(l-1,k),zPoints(l,k),zPoints(l-1,k));
                
                    FxDown = kPart * (stretchedLengthDown-lengthPart)*( ( xPoints(l-1,k)-xPoints(l,k) ) / stretchedLengthDown);
                    FyDown = kPart * (stretchedLengthDown-lengthPart)*( ( yPoints(l-1,k)-yPoints(l,k) ) / stretchedLengthDown);
                    FzDown = kPart * (stretchedLengthDown-lengthPart)*( ( zPoints(l-1,k)-zPoints(l,k) ) / stretchedLengthDown);
                else
                    FxDown = 0;
                    FyDown = 0;
                    FzDown = 0;
                end
                
                Fx = FxUp + FxDown + FxRight + FxLeft;
                Fy = FyUp + FyDown + FyRight + FyLeft;
                Fz = FzUp + FzDown + FzRight + FzLeft - (massPart * 9.82);
                
                Ftot = sqrt(Fx^2+Fy^2+Fz^2);
                
                forces(l,k) = Ftot;
        
                
                newYPoints(l,k) = yPoints(l,k) + (alpha * Fy);
                newXPoints(l,k) = xPoints(l,k) + (alpha * Fx);
                newZPoints(l,k) = zPoints(l,k) + (alpha * Fz);
           end 
        end
    end
        
      xPoints = newXPoints;
      yPoints = newYPoints;
      zPoints = newZPoints;
      
      forceMax = max(forces);
end

%% Plot

surf(xPoints,yPoints,zPoints)

