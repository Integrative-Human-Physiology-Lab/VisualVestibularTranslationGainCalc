%calculating the translation of the scene

clc
clear
close all

frequencies =   [0.03   0.1     0.18  0.06]; %Hz
amplitude  =    [25     25      25     25]; % degrees
t  = 0:0.0001:100;

g = 9.8; %m/s^2

angles =  NaN(length(frequencies),length(t));
for i = 1:length(frequencies)
    angles(i,:) = amplitude(i) *cos(t.*frequencies(i)*2*pi);
end

g_utricle = g*sind(angles);

v_utricle = NaN(length(frequencies),length(t));
p_utricle = NaN(length(frequencies),length(t));
for i = 1:length(frequencies)
v_utricle(i,:) = cumtrapz(t,g_utricle(i,:));
end

for i = 1:length(frequencies)
    p_utricle(i,:) = cumtrapz(t,v_utricle(i,:));
    p_utricle(i,:) = p_utricle(i,:) -max(p_utricle(i,:))/2;
end


figure
subplot(4,1,1)
plot(t,angles)
xlabel('t (sec)')
ylabel('angle (degrees)')
title(['\theta  = ', num2str(amplitude),'sin(t*\omega)'])
subplot(4,1,2)
plot(t,g_utricle)
xlabel('t (sec)')
ylabel('g_{utricle}  (m/s^2)')
title('g_{utricle} = g*sin(\theta)')
subplot(4,1,3)
plot(t,v_utricle)

xlabel('t (sec)')
ylabel('v_{utricle}  (m/s)')
title('v_{utricle} = \int g_{utricle}')

subplot(4,1,4)
plot(t,p_utricle)
xlabel('t (sec)')
ylabel('p_{utricle}  (m)')
title('p_{utricle} = \int v_{utricle}')

legendCell = strcat('f=',string(num2cell(frequencies)));

legend(legendCell)


%Gain Calculations (m/deg)
gains = max(p_utricle')./amplitude;

gainsTable = table;
gainsTable.frequenciesHz = frequencies';
gainsTable.amplitude_deg = amplitude';
gainsTable.gains_m_per_deg = gains';
gainsTable
