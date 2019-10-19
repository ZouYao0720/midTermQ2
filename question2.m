clear;clc;
%%% define the parameters
K =10;
N = 1;
sigma1 = 0.3;
sigma2 = 0.25;
phi = 0;
TruePosition = [-0.3;0.5];
theta = 2*pi/K;
landmark = [cos(((1:K)-1)*theta);sin(((1:K)-1)*theta)];
distance = sqrt((landmark(1,:)-TruePosition(1)).*(landmark(1,:)-TruePosition(1))+(landmark(2,:)-TruePosition(2)).*(landmark(2,:)-TruePosition(2))); %%% generate the true distance 

%%% sample the mearsurment, resample it when the r is negative
for nn = 1:K
    for n = 1:N
        k = sigma1*randn(N,1);
        while (k + distance(nn))<0
            k = sigma1*randn(N,1);
        end
        sampleR(n,nn) = k+distance(nn);
    end
end
%x = 0;
%y = 0;
z = zeros(401,401);
yy = zeros(401,401);
col = 1;
row = 1;
minValue = -100000;
Xmap=0;
Ymap=0;

%%% search the map x and y
for x = -2:0.01:2
     for y = -2:0.01:2
         for nn = 1:K
             %landmark(1,nn)
             %landmark(2,nn)
             z(row,col) = z(row,col)- (sampleR(nn)-sqrt((x-landmark(1,nn))^2+(y-landmark(2,nn))^2))^2/(2*sigma1^2);
         end
         z(row,col) = z(row,col) - (x.^2+y.^2)/(2*sigma2^2);
         yy(row,col) = -(sum((sampleR-sqrt((x-landmark(1,:)).^2+(y-landmark(2,:)).^2)).^2))/(2*sigma1^2)-(x.^2+y.^2)/(2*sigma2^2);
         if z(row,col) > minValue
             minValue = z(row,col);
             Xmap = x;
             Ymap = y;
         end
         col = col+1;
     end
     row = row+1;
     col = 1;
end
 
%%% write the object funtion of MAP
f = @(x,y)  -(sum((sampleR-sqrt((x-landmark(1,:)).^2+(y-landmark(2,:)).^2)).^2))/(2*sigma1^2)-(x.^2+y.^2)/(2*sigma2^2);
figure(1)
fcontour(f,'LineWidth',2,'MeshDensity',100,'LevelStep',1)
hold on
plot(landmark(1,:),landmark(2,:),'o');
plot(TruePosition(1,:),TruePosition(2,:),'+');
plot(Xmap,Ymap,'*');
xlabel("X axis")
ylabel("Y axis")
title("Contour of MAP objective funtion")
legend('contours',"landmarks","True position","MAP postion")
axis([-2 2 -2 2]);

