function plotAttMed( att, med )
%PLOTATTMED Plot Mindwave attention and meditation parameters
%   Takes mindwave values and plots them with consistent scaling

figure
subplot(2,1,1)
plot(att), ylabel('Attention'), ylim([0 100])
subplot(2,1,2)
plot(med), ylabel('Meditation'), ylim([0 100])
drawnow;

end

