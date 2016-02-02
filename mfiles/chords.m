hold on
numFrames = 105;
diameter = 6;
radius = diameter/2;

circle(radius,0,radius);  % (x,y,r)

spacing = diameter/(numFrames-1);
xvals = 0:spacing:diameter;

chord = 2*sqrt((radius^2)-(abs(xvals-radius).^2));

for i = 1:length(xvals)
    x=[xvals(i), xvals(i)];
    y=[-chord(i)/2, chord(i)/2];
    plot(x,y)
end

%True area
area = pi*radius^2

%Trapezoid estimation
trap = trapz(xvals, chord)

% Simpson estimation
simp = simps(xvals, chord)

%spline estimation
pp = spline(xvals, chord); 
splineIntegral = ppint(pp,xvals(1),xvals(end))

% if even number of frames