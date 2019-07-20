%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This is MATLAB script to simulate rate of uptake of nanoparticles from 
% the blood into the liver, tumour, and other organs and their total 
% accumulations over 24 hours.
% 
% This MATLAB script solves the ODE posed by a compartment model of 
% nanoparticle transport.
% 
% TumourLiverDose.m is a function called within simulate_TumourLiverDose.m
% 
% To run this file, set MATLAB path to both files (probably in the same 
% folder), then run simulate_TumourLiverDose.m
%
% * note there are two USER INPUTS that can be changed in simulate_TumourLiverDose.m
% * 1. Dose can be toggled to a low dose or a high dose.
% * 2. Output plot can be selected to be either uptake rate vs time or total uptake vs time.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; clc;
tic

%initialize doses
highDose = 5e3;
lowDose = highDose/256;

% USER INPUT SECTION
initialDose = highDose;     %initialDose must equal either 'lowDose' or 'highDose'
whichPlot = 2;              %for rates of uptake, set to 1. for total uptake, set to 2.
% END USER INPUT SECTION

t = [0 24];     %time over 24 hours; units=hour

k_T=1e-18;      %out of tumour; negligible
k_L=1e-18;      %out of liver; negligible
k_O=1e-18;      %out of "other" organs; negligible
k_I=1e-18;      %out of Kupffer cells; negligible

kL=4e-3;        %into liver KCs
kT=0.53e-6;     %into tumour
kO=8e-5;        %into "other" organs
kI=2e-5;        %into liver other cells

L0=1e2;         %liver limit (1 trillion)
O0=1.8e3;       %other organ limit (arbitrary)
I0=2.3e3;       %other cell limit (arbitrary)
T0=L0+I0*5;     %tumour limit same as liver (arbitrary)

% calculate tumour, liver, blood
[t,y] = ode23('TumourLiverDose',t,[initialDose 0 0 0 0],[],kT,k_T,kL,kI,k_L,kO,k_O,k_I,L0,T0,O0,I0);

NP=y(:,1)./initialDose*100/2;               %blood concentration ID/g (2 = blood weight)
NP2 = NP*2;                                 %total in the blood
NPL=(y(:,2)+y(:,5))./initialDose*100/1;     %liver concentration ID/g (1 = liver weight)
NPT=y(:,3)./initialDose*100/0.3;            %tumour concentration ID/g (0.3 = tumour weight)
NPO=y(:,4)./initialDose*100/18;             %other organ concentration ID/g (18 = "other organ" weight)
L=L0-y(:,2);
T=T0-y(:,3);
O=O0-y(:,4);

%get derivatives
diffNP = diff(NP);                          %difference vector of blood
diffNPL = diff(NPL);                        %difference vector of liver
diffNPT = diff(NPT);                        %difference vector of tumour
dt = diff(t);                               %difference vector of time

dNP = diffNP./dt;                           %difference vector of blood
dNPL = diffNPL./dt;                         %difference vector of liver
dNPT = diffNPT./dt;                         %difference vector of tumour
rateRatio = dNPL./dNPT;                     %ratio between liver and tumour rates

%plotting section starts here
set(0,'DefaultFigureWindowStyle','docked')  %keep the graph in MATLAB panel

if whichPlot == 1 %plot the accumulation RATES
    p = plot(t(2:end),dNP,'r',t(2:end),dNPL,'b',t(2:end),dNPT,'g');
    legend('Blood','Liver','Tumour','Other');
    xlabel('Time (hours)') 
    ylabel('Uptake Rate (%ID/g per hour)') 
    p(1).LineWidth = 2;
    p(2).LineWidth = 2;
    p(3).LineWidth = 2;
elseif whichPlot == 2 %plot the accumulation AMOUNTS
    p = plot(t,NP,'r',t,NPL,'b',t,NPT,'g',t,NPO,'c');
    legend('Blood','Liver','Tumour','Other');
    xlabel('Time (hours)') 
    ylabel('%ID/g') 
    p(1).LineWidth = 2;
    p(2).LineWidth = 2;
    p(3).LineWidth = 2;
    p(4).LineWidth = 2;
end

data = [t NP NPL NPT NPO];
toc
