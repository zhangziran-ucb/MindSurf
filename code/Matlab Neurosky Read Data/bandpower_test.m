% compare brainwave bandpowers to mindwave outputs
clear all
close all

% Import sample data
mindwave = csvread('Trial_03.csv', 1, 0);
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

% take signal in 512 sample segments starting at 274
% take bandpower of each brainwave for each segment
% plot those
% plot the values given by mindwave, one from each segment
% my values in row 1, mindwave powers in row 2
pow_a = [];
pow_b = [];
pow_g = [];
pow_d = [];
pow_t = [];
att = []; med = [];
s = 274;
raw = mindwave(:,4);

for i = 1:(length(mindwave)/512)-1
    sig = raw(s:s+511); 
    
    pow_a(1,i) = bandpower(sig,512,[8 13]);
    pow_b(1,i) = bandpower(sig,512,[13 30]);
    pow_g(1,i) = bandpower(sig,512,[40 80]);
    pow_d(1,i) = bandpower(sig,512,[0.1 4]);
    pow_t(1,i) = bandpower(sig,512,[4 8]);
    
    pow_a(2,i) = mindwave(s,8);
    pow_b(2,i) = mindwave(s,10);
    pow_g(2,i) = mindwave(s,12);
    pow_d(2,i) = mindwave(s,5);
    pow_t(2,i) = mindwave(s,6);
    
    att(i) = mindwave(s,2);
    med(i) = mindwave(s,3);
    
    s = s + 512;
end

figure(1)
subplot(5,2,1), plot(pow_a(1,:)), ylabel('alpha')
title('Waveband power vs time')
subplot(5,2,3), plot(pow_b(1,:)), ylabel('beta')
subplot(5,2,5), plot(pow_g(1,:)), ylabel('gamma')
subplot(5,2,7), plot(pow_d(1,:)), ylabel('delta')
subplot(5,2,9), plot(pow_t(1,:)), ylabel('theta')

subplot(5,2,2), plot(pow_a(2,:))
title('Mindwave outputs vs time')
subplot(5,2,4), plot(pow_b(2,:))
subplot(5,2,6), plot(pow_g(2,:))
subplot(5,2,8), plot(pow_d(2,:))
subplot(5,2,10), plot(pow_t(2,:))

figure
subplot(2,1,1), plot(att)
title('Mindwave attention vs time')
subplot(2,1,2), plot(med)
title('Mindwave meditation vs time')