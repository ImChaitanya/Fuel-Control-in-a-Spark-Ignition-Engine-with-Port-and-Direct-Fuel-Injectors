%% EE5812 Automotive Control Systems
%  Auto Grading: Project 1
%  9/24/2017

%% ------------------------------------------------------------------ %%
%  ------ NOTE:  Please save the measured lambda as "lambda_m" ------  %
%  ------------------------------------------------------------------ %%

%% Parameters
Name_variable = 'lambda_m';       % Variable Name
Steady_state_value = 1;           % Steady state value = 1

Settlingtime_percentage = 0.05;   % 0.95 or 1.05
Settlingtime_thres_upper = Steady_state_value*(1+Settlingtime_percentage);
Settlingtime_thres_lower = Steady_state_value*(1-Settlingtime_percentage);

if (choice_p == 1) && (choice_r == 1)       % Perfect Parameter and AFs = 14.64
    OS_d = 4.5;                             % Desired persentage overshoot  [%]
    Time_settling_d = 1.1;                  % Desired Settling time [sec]
    lambda_err_max_d = 0.0011;              % The desired maximum lambda error between the mueasured lambda and the desired lambda (from 20 sec to 26 sec)
    Diff_air_fuel_range_d = [-0.02 0.09];   % The desired range of the difference between the normalized air and the injected fuel
    Thres_ss_diff = 0.005;                  % The Steady State Error
elseif (choice_p == 1) && (choice_r == 2)   % Perfect Parameter and AFs = 14.4
    OS_d = 4.5;                             % Desired persentage overshoot  [%]
    Time_settling_d = 1.1;                  % Desired Settling time [sec]
    lambda_err_max_d = 0.0011;              % The desired maximum lambda error between the mueasured lambda and the desired lambda (from 20 sec to 26 sec)
    Diff_air_fuel_range_d = [-0.02 0.09];   % The desired range of the difference between the normalized air and the injected fuel
    Thres_ss_diff = 0.005;                  % The Steady State Error
elseif (choice_p == 2) && (choice_r == 1)   % Imperfect Parameter and AFs = 14.64
    OS_d = 5;                               % Desired persentage overshoot  [%]
    Time_settling_d = 1.1;                  % Desired Settling time [sec]
    lambda_err_max_d = 0.01;                % The desired maximum lambda error between the mueasured lambda and the desired lambda (from 20 sec to 26 sec)
    Diff_air_fuel_range_d = [-0.02 0.1];    % The desired range of the difference between the normalized air and the injected fuel 
    Thres_ss_diff = 0.025;                  % The Steady State Error
else                                        % Imperfect Parameter and AFs = 14.4
    OS_d = 5;                               % Desired persentage overshoot  [%]
    Time_settling_d = 1.1;                  % Desired Settling time [sec]
    lambda_err_max_d = 0.01;                % The desired maximum lambda error between the mueasured lambda and the desired lambda (from 20 sec to 26 sec)
    Diff_air_fuel_range_d = [-0.02 0.1];    % The desired range of the difference between the normalized air and the injected fuel 
    Thres_ss_diff = 0.025;                  % The Steady State Error
end


%% Grading
if exist(Name_variable,'var') == 1    % Check if the variable 'lambda_m' exists (if YES)
            %% SS, OS and Settling Time Check
            Diff = (lambda_m(end-200:end) - Steady_state_value)*100;  % The difference in [%] between the measured value and the theory steady-state value
            Diff_min_abs = abs(min(Diff));
            if Diff_min_abs <= Thres_ss_diff
                Grade_ss = 'Full credit';
                Comment_ss = ['Full Credit: The steady-state error is less than ', num2str(Thres_ss_diff),' [%]'];
            elseif Diff_min_abs <= 2*Thres_ss_diff  
                Grade_ss = 'Half credit';
                Comment_ss = ['Half Credit: The steady-state error is more than ', num2str(Thres_ss_diff),' [%] but less than ', num2str(2*Thres_ss_diff),' [%]'];
            else
                Grade_ss = 'No credit';
                Comment_ss = ['No Credit: The steady-state error is more than ',num2str(2*Thres_ss_diff),' [%])'];
            end
            % Overshoot Calculation
            Lambda_max = max(lambda_m(:,2));
            OS_Measured = (Lambda_max-Steady_state_value)*100/Steady_state_value;   % The measured overshoot
            % Settling Time Calculation
            Cntr = 1;
            for aa = 1:1000
                if (lambda_m(aa,2) <= Settlingtime_thres_lower) | (lambda_m(aa,2) >= Settlingtime_thres_upper)
                    Settlingtime_Data(Cntr,:) =  lambda_m(aa,:);
                    Cntr = Cntr + 1;
                end
            end
            SettlingTime_Measured = max(Settlingtime_Data(:,1));
            % Overshoot Check
            if OS_Measured <= OS_d
                Grade_os = 'Full credit';      % Full credits
                Comment_os = ['Full Credit: Overshoot Percentage is less than ', num2str(OS_d),' [%]'];
            elseif OS_Measured <= 1.5*OS_d
                Grade_os = 'Half credit';    % Half credits
                Comment_os = ['Half Credit: Overshoot Percentage is more than ', num2str(OS_d),' [%] but less than ', num2str(1.5*OS_d),' [%]'];
            else
                Grade_os = 'No credit';    % No credits
                Comment_os = ['No Credit: Too much Overshoot! (More than ',num2str(1.5*OS_d),' [%])'];
            end
            % Settling Time Check
            if SettlingTime_Measured <= Time_settling_d
                Grade_st = 'Full credit';      % Full credits
                Comment_st = ['Full Credit: Settling Time is less than ', num2str(Time_settling_d),' [Sec]'];
            elseif SettlingTime_Measured <= 1.5*Time_settling_d
                Grade_st = 'Half credit';      % Half credits
                Comment_st = ['Half Credit: Settling Time is more than ', num2str(Time_settling_d), ' [Sec] but less than ', num2str(1.5*Time_settling_d),' [Sec]'];
            else
                Grade_st = 'No credit';    % No credits
                Comment_st = ['No Credit: Settling Time is too much! (More than ',num2str(1.5*Time_settling_d),' [Sec])'];
            end
            

        
        %% Differeces between Normalized Air and Injected Fuel
        Diff_air_fuel = InjectedAirandFuel(:,2)-InjectedAirandFuel(:,3);
        Diff_air_fuel_max = max(Diff_air_fuel);
        Diff_air_fuel_min = min(Diff_air_fuel);
       if (Diff_air_fuel_max <= Diff_air_fuel_range_d(2)) && (Diff_air_fuel_min >= Diff_air_fuel_range_d(1))
            Grade_air_fuel = 'Full credit';      % Full credits
            Comment_diff = ['Full Credit: The diff. between air_norm and fuel_in is within [',num2str(Diff_air_fuel_range_d(1)),', ',num2str(Diff_air_fuel_range_d(2)),']'];
        elseif (Diff_air_fuel_max <= 1.2*Diff_air_fuel_range_d(2)) && (Diff_air_fuel_max >= 1.2*Diff_air_fuel_range_d(1))
            Grade_air_fuel = 'Half credits';      % Half credits
            Comment_diff = ['Half Credit: The diff. between air_norm and fuel_in is within [',num2str(1.2*Diff_air_fuel_range_d(1)),', ',num2str(1.2*Diff_air_fuel_range_d(2)),']'];
        else
            Grade_air_fuel = 'No credit';      % No credits
            Comment_diff = ['No Credit: The diff. between air_norm and fuel_in is out of [',num2str(1.2*Diff_air_fuel_range_d(1)),', ',num2str(1.2*Diff_air_fuel_range_d(2)),']'];
        end
        
        %% Max lambda Error Check
        lambda_err_max = max(lambda_m(2000:2600,2))-1;
        if lambda_err_max <= lambda_err_max_d 
            Grade_lambda_err = 'Full credit';      % Full credits
            Comment_lambda_err = ['Full Credit: The transient lambda error after time = 20 is less than ',num2str(lambda_err_max_d)];
        elseif lambda_err_max <= 1.5*lambda_err_max_d
            Grade_lambda_err = 'Half credit';      % Half credits
            Comment_lambda_err = ['Half Credit: The transient lambda error after time = 20 is more than ',num2str(lambda_err_max_d),' but less than ',num2str(1.5*lambda_err_max_d)];
        else
            Grade_lambda_err = 'No credit';      % Half credits
            Comment_lambda_err = ['No Credit: The transient lambda error after time = 20 is more than ',num2str(1.5*lambda_err_max_d)];
        end
        

        
        %% Plotting
        % Plotting
        if choice_p == 1 && choice_r == 1
            lbl = 'Perfect Parameters and AFc = 14.64';
        elseif choice_p == 2 && choice_r == 1
            lbl = 'Imperfect Parameters andz AFc = 14.64';
        elseif choice_p == 1 && choice_r == 2
            lbl = 'Perfect Parameters and AFc = 14';
        elseif choice_p == 2 && choice_r == 2
            lbl = 'Imperfect Parameters and AFc = 14';
        end
        
        %% Display Comments
%         disp(Comment_os)
%         disp(Comment_st)
%         disp(Comment_diff)
%         disp(Comment_lambda_err)
        MSGBOX = msgbox({Comment_ss,Comment_os,Comment_st,Comment_diff,Comment_lambda_err},'Comments');
        set(MSGBOX, 'position', [120 220 550 200]);
        ah = get( MSGBOX, 'CurrentAxes');
        ch = get( ah, 'Children');
        set( ch, 'FontSize', 15); 
        
        figure(1);
        plot(lambda_m(:,1),lambda_m(:,2)); grid minor;
        xlabel('Time [Sec]');
        ylabel('Lambda-m');
        title(['Lambda-m vs. Time with ',lbl]);
        tx5 = text(15,0.4,['SS: ',num2str(abs(min(Diff))),' [%] | Grade: ', Grade_ss]); tx5.Color = [0 0 1];
        tx1 = text(15,0.3,['OS: ',num2str(OS_Measured),' [%] | Grade: ', Grade_os]); tx1.Color = [0 0 1];
        tx2 = text(15,0.2,['Settling Time: ',num2str(SettlingTime_Measured),' [Sec] | Grade: ', Grade_st]); tx2.Color = [0 0 0];
        tx4 = text(15,0.1,['Lambda Error: ',num2str(lambda_err_max),' | Grade: ', Grade_lambda_err]); tx4.Color = [1 0 0];
        savefig(figure(1),['lambda ', lbl,'.fig']);
        
        figure(2);
        plot(InjectedAirandFuel(:,1),InjectedAirandFuel(:,2),'r'); hold on;
        plot(InjectedAirandFuel(:,1),InjectedAirandFuel(:,3),'b'); hold off; grid minor;
        legend('Normalized Air','Injected Fuel');
        xlabel('Time [Sec]');
        ylabel('Normalized Air and Injected Fuel');
        title(['Normalized Air/Injected Fuel vs Time with ',lbl]);
        tx3 = text(2,0.2,['Max. Diff. between Normalized Air and Injected Fuel: ',num2str(Diff_air_fuel_max)]); tx3.Color = [0 0.5 1];
        tx6 = text(2,0.1,['Min. Diff. between Normalized Air and Injected Fuel: ',num2str(Diff_air_fuel_min),' | Grade: ', Grade_air_fuel]); tx6.Color = [0 0.5 1];
        savefig(figure(2),['AF ', lbl,'.fig']);
%         close all;

else        % Check if the variable 'lambda_m' exists (if NOT)
	msgbox(['The Variable [' Name_variable '] is MISSING! Please Check the Variable Name!'],'Comments');
end




