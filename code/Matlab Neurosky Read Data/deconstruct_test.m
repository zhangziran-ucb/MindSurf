% Compare deconstructRAW.m to mindwave computed brainwaves
clear

% Import sample data
mindwave = csvread('Trial_00.csv', 1, 0);
mindwave(:,1:2) = [];
% Import smarter later. For now, columns are:
% 1: poor signal
% 2: attention
% 3: meditation
% 4: raw
% 5: delta
% 6: theta
% 7: alpha1
% 8: alpha2
% 9: beta1
% 10: beta2
% 11: gamma1
% 12: gamma2
% 13: blink

first_sec = mindwave(274:785,:);
[alpha, beta, gamma, delta, theta] = deconstructRAW(first_sec(:,4));

figure
subplot(5, 1, 1)
plot(alpha)
subplot(5, 1, 2)
plot(beta)
subplot(5, 1, 3)
plot(gamma)
subplot(5, 1, 4)
plot(delta)
subplot(5, 1, 5)
plot(theta)

second_sec = mindwave(786:1297,:);
[alpha2, beta2, gamma2, delta2, theta2] = deconstructRAW(second_sec(:,4));

figure
subplot(5, 1, 1)
plot(alpha2), ylabel('alpha')
subplot(5, 1, 2)
plot(beta2), ylabel('beta')
subplot(5, 1, 3)
plot(gamma2), ylabel('gamma')
subplot(5, 1, 4)
plot(delta2), ylabel('delta')
subplot(5, 1, 5)
plot(theta2), ylabel('theta')

double_window = mindwave(274:1297,:);
[a, b, g, d, t] = deconstructRAW(double_window(:,4));

figure
subplot(5, 1, 1)
plot(a), ylabel('alpha')
subplot(5, 1, 2)
plot(b), ylabel('beta')
subplot(5, 1, 3)
plot(g), ylabel('gamma')
subplot(5, 1, 4)
plot(d), ylabel('delta')
subplot(5, 1, 5)
plot(t), ylabel('theta')

