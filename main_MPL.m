%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation of a single-server scenario                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clearvars;      % Clear Variables from Memory
clc;            % Clear Command Window

CNa = 0;        % Current Number of Arrived Customers
CNl = 0;        % Current Number of Lost Customers
CNd = 0;        % Current Number of Departed Customers

Na = 0;         % Number of Arrived Customers
Nl = 0;         % Number of Lost Customers
Nd = 0;         % Number of Departed Customers

c = 0;          % Number of Simulations

meansn = 0;     % Average Number of Lost Customers
variance = 0;   % How strong the Average Number of Lost Customers (mean) varies



% Terminate Simulation, if Stop Criterion is met
while true
  
  c = c + 1;        % Increase Number of Simulation
    
  deadline = 100;   % System Closing Time
  rate = 5;         % Rate for HPP (Calculation of Arrival Time of Next Customer)
  
  % Call the Simulation Process
  [CNa, CNl, CNd] = SingleServer_MPL(deadline, rate);
  
  
  Na = Na + CNa;    % Add Current Number of Arrivals to Number of Arrivals
  Nl = Nl + CNl;    % Add Current Number of Losts to Number of Losts
  Nd = Nd + CNd;    % Add Current Number of Departures to Number of Departures
  

  if c >= 2
      % Special Case Exactly in the 2nd Number of Simulation
         if c == 2
          meansn1 = (1/(c + 1)) * (c * CNl + CNl);
          variance = (1-(1/c)) * variance + (c+1) * (meansn1 - meansn).^2;
          meansn = meansn1;
         end
      
         
      % Calculate:
      % - Mean (Average Number of Lost Customers), and 
      % - Variance (How strong does Mean Value vary)
      meansn1 = (1/(c + 1)) * (c * meansn + CNl);
      varianceold = variance;
      variance = (1-(1/c)) * variance + (c+1) * (meansn1 - meansn).^2;
      meansn = meansn1;
      
      
      % Calculate Width of Confidence interval (95% confidence)
      % - Value (1.96) is from Standard Normal Distribution Table (equal to 95% confidence)
      confint = (2*1.96) * ((sqrt(variance))/sqrt(c));
      
      
      % Defining the Stop Criterion for Terminating the Simulation
      stopcriterion = confint / meansn;
           
      if mod(c,10) == 0
          disp([' ']);
          disp(['----------------------------------------']);
          disp(['SIMULATION ROUND: ' num2str(c)]);
          disp(['----------------------------------------']);
          disp([' ']);
          disp(['Confidence Interval:' char(9) char(9) num2str(confint)]);
          disp(['Stop Criterion:' char(9) char(9) char(9) num2str(stopcriterion)]);
          disp(['Mean:' char(9) char(9) char(9) char(9) num2str(meansn)]);
          disp(['Variance:' char(9) char(9) char(9) num2str(variance)]);
          disp(['Current Arrived Customers:' char(9) num2str(CNa)]);
          disp(['Number of Arrived Customers:' char(9) num2str(Na)]);
          disp(['Current Departed Customers:' char(9) num2str(CNd)]);
          disp(['Number of Departed Customers:' char(9) num2str(Nd)]);
          disp(['Current Lost Customers:' char(9) char(9) num2str(CNl)]);
          disp(['Number of Lost Customers:' char(9) num2str(Nl)]);
          disp(['Percentage of Lost Customers:' char(9) num2str(Nl/Na*100) '%']);
          disp([' ']);
      end

      
      % Stop Simulation when Width of Confidence Interval is sufficiently small
      if stopcriterion < 0.01
          break;
      end
      
  end
end   


disp([' ']);
disp(['========================================']);
disp(['=          END OF SIMULATION           =']);
disp(['========================================']);
disp(['Number of Simulations:']);
disp(['' num2str(c)])
disp([' '])
disp(['Number of Arrived Customers:']);
disp(['' num2str(Na)])
disp([' '])
disp(['Number of Lost Customers:']);
disp(['' num2str(Nl)])
disp([' '])
disp(['Number of Departed Customers:']);
disp(['' num2str(Nd)])
disp([' '])
disp(['Percentage of Lost Customers:']);
disp(['' num2str(Nl/Na*100) '%']);
disp([' ']);
disp(['========================================']);
disp(['=============END OF SCRIPT==============']);
disp(['========================================']);
disp([' ']);


