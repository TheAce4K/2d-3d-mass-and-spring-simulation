%% variabler
masses = 31;
springs = masses-1;
K = 1;
kPart = K*springs;
massTot = 1;
massPart = massTot/masses;
originaLength = 1;
lengthPart = 1/springs;
alpha = 0.01;

forces = zeros(1,masses);
forceMaxPerIteration = [];

%% skapa  bestämda punkter
% col 1 x, col2 y, col 3 new x, col 4 new y
points = zeros(masses,4);

fixedPoint2Pos = round((masses+1)/3);
fixedPoint3Pos = round((masses+1)*2/3);
% x värden

points(1:fixedPoint2Pos,1)=linspace(0,1/3,fixedPoint2Pos);
% genererar punkter jämt fördelat mellan 1/3 och 2/3
AmountPointsBetween = fixedPoint3Pos-fixedPoint2Pos-1;
PointsBetween = linspace(1/3,2/3,AmountPointsBetween+2);
points(fixedPoint2Pos+1:fixedPoint3Pos-1,1) = PointsBetween(2:AmountPointsBetween+1);

points(fixedPoint3Pos:end,1) = linspace(2/3,1,(length(points)-fixedPoint3Pos+1));

%y värden
points(1:fixedPoint2Pos,2) = linspace(0,1,fixedPoint2Pos);
points(fixedPoint2Pos:fixedPoint3Pos,2) = linspace(1,1,(fixedPoint3Pos-fixedPoint2Pos+1));
points(fixedPoint3Pos:end,2) = linspace(1,0,(length(points)-fixedPoint3Pos+1));

points(:,3) = points(:,1);
points(:,4) = points(:,2);

%% fixpunktsiterera fram punkternas positioner

% fixpunkts iterera tills kraften är tillräkligt liten
forceMax = 1;
while forceMax > 10^-6
    % gör fixpunktsiterationen för alla punkter förutom de redan bestämda
    for k = 2:masses-1
        if k ~= fixedPoint2Pos && k ~= fixedPoint3Pos
            stretchedLength = @(xi,xj,yi,yj) sqrt((xj-xi)^2 + (yj-yi)^2);
            
            stretchedLengthRight = stretchedLength(points(k,1), points(k+1,1), points(k,2), points(k+1,2));
            FxRight = kPart * (stretchedLengthRight-lengthPart)*( ( points(k+1,1)-points(k,1) ) / stretchedLengthRight);
            FyRight = kPart * (stretchedLengthRight-lengthPart)*( ( points(k+1,2)-points(k,2) ) / stretchedLengthRight);
            
            stretchedLengthLeft = stretchedLength(points(k,1), points(k-1,1), points(k,2), points(k-1,2));
            FxLeft = kPart * (stretchedLengthLeft-lengthPart)*( ( points(k-1,1)-points(k,1) ) / stretchedLengthLeft);
            FyLeft = kPart * (stretchedLengthLeft-lengthPart)*( ( points(k-1,2)-points(k,2) ) / stretchedLengthLeft);
            
            Fx = FxRight + FxLeft;
            
            Fy = FyRight + FyLeft - (massPart * 9.82) ;
            
            Ftot = sqrt(Fx^2 + Fy^2);
            forces(k) = Ftot;
            
            newY = points(k,2) + (alpha * Fy);
            newX = points(k,1) + (alpha * Fx);
            
            points(k,3) = newX;
            points(k,4) = newY;
            
        end
        
    end
    points(:,1) = points(:,3);
    points(:,2) = points(:,4);
    forceMax = max(forces);
    forceMaxPerIteration = [forceMaxPerIteration forceMax];
end

%% Plot
figure(1)
plot(points(:,1),points(:,2))
figure(2)
X = linspace(1,length(forceMaxPerIteration),length(forceMaxPerIteration));
semilogy(X,forceMaxPerIteration)
%% test

