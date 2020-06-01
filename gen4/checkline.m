
clf

subplot(2,1,1)
hold on
im1 = imread('trimsmall1.png');
im2 = imread('trimsmall2.png');
l1 = im1(250,1:end);
l2 = im2(250,1:end);
plot(l1)
plot(l2)
legend('1','2')


subplot(2,1,2)
hold on
im1 = imread('retrimsmall1.png');
im2 = imread('retrimsmall2.png');
l1 = im1(250,1:end);
l2 = im2(250,1:end);
plot(l1)
plot(l2)
legend('1','2')

