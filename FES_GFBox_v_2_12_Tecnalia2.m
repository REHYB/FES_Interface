%% About
% Project Name      : FES-GripForce-Qualisys Code for FES Device
% This File Name    : FES_GFBox_v_2_12.m
% Duty of this File : FES-GripForce-Qualisys simple Interface for
% controlling FES manually/automatically
% Type              : Matlab Code
% Compatible with   : Windows
% version           : 12.2
% Initial Date      : 20210603
% Last Modification : 20210927
% Modified by       : HKR
% Place             : ITR - TUM - Munchen - Germany
% Project           : ReHyb
% 
% Note:
% Hint:
% =========================================================================================//
%% Help
% 1) Enter the FES COMport number in FESCOMNo.txt (for instance: COM4) 
%  In Windows, after pairing the FES with your computer, you can find comport here:
%  Settings>Bluetooth & other devices>More Bluetooth options>Compot tab
% 
% 2) Run the Pogram "FES_User_Interface_v_2_12_Tecnalia.m"
% 
% 3) Apart from general use of the program, for simplification we consider one simple automatic option:
% after running the program just go to "Setting" tab and then choose "General Initialization" Then you have access to 
% Control Panel in "DefineNewVelec" window. 
% =========================================================================================//

clear all, close all, clc;
global G
addpath("Functions");
Initialize_Interface(0, 0);
