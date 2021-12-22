%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulation of a single-server scenario                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [Na, Nl, Nd] = SingleServer_MPL(deadline, rate)

  %%%%%%%%%%%%%%%%%%
  % Time Variables %
  %%%%%%%%%%%%%%%%%%
  t = 0;            % Current Time t
  T = deadline;     % System Closing Time. NO further Customers are allowed to Enter the System

  
  %%%%%%%%%%%%%%%%%%%%%
  % Counter Variables %
  %%%%%%%%%%%%%%%%%%%%%
  Na = 0;   % Number of Arrived Customers
  Nd = 0;   % Number of Departed Customers
  Nl = 0;   % Number of Lost Customers
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%
  % System State Variable %
  %%%%%%%%%%%%%%%%%%%%%%%%%
  n = 0;    % Number of Customers in the System

  
  %%%%%%%%%%%%%%
  % Event List %
  %%%%%%%%%%%%%%
  ta = HPP(rate);   % Arrival Time of Next Customer
  td = inf;         % Service Completion Time of the Customer Presently being served
  tl = [];          % Leaving Times of Currently Waiting Customers

  
  
  while true
    %%%%%%%%%%%%%%%%%%%%
    % Case 1 (Arrival) %
    %%%%%%%%%%%%%%%%%%%%
    % ARRIVAL TIME OF NEXT CUSTOMER  is before  SERVICE COMPLETION TIME of the CUSTOMER PRESENTLY being SERVED and 
    % ARRIVAL TIME OF NEXT CUSTOMER  is before  SYSTEM CLOSING TIME
    if ta <= td && ta <= T
      t = ta;               % Current Time is Arrival Time of Next Customer
      Na = Na + 1;          % A new Customer has arrived, so Number of Arrived Customers increases
      n = n + 1;            % Number of Customers in the System increases
      ta = t + HPP(rate);   % Calculate Arrival Time of Next Customer
            
      tl = [tl, t + F];     % tl  = Leaving Times of Currently Waiting Customers
                            % t+F = Current Time and Random Waiting Time between 0 and 5 
                            % Each Customer will only Wait a Random amount of Time, having Distribution F, in Queue, before Leaving the System
            
      if n == 1             % If there is Only One Customer in System
        Y = G;              % (G denotes the Service Distribution (Exponential Random Variable with Rate 4))
        td = t + Y;         % Calculate new Service Time of the Customer Presently being served
      end
      
      continue;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%
    % Case 2 (Departure) %
    %%%%%%%%%%%%%%%%%%%%%%
    % SERVICE COMPLETION TIME of the CUSTOMER PRESENTLY being SERVED  is before  ARRIVAL TIME OF NEXT CUSTOMER and
    % SERVICE COMPLETION TIME of the CUSTOMER PRESENTLY being SERVED  is before  SYSTEM CLOSING TIME
    if td < ta && td <= T
      t = td;               % Current Time is Service Completion Time of the Customer presently being served
      n = n - 1;            % Number of Customers in the System decreases, because a Customer has been served
      
      lost = tl(1) < td;    % Leaving Times of Currently Waiting Customers is before Service Completion Time of the Customer Presently being served
      tl = tl(2:end);
      
      if lost               % If there is one Customer who left the System before he or she was served
        Nl = Nl + 1;        % Number of Lost Customers increases
      else                  % ELSE (Customer stays in System and waits until he or she is served)
        Nd = Nd + 1;        % Number of Departed Customers increases
      end
      
      if n == 0             % If there is no other Customer in System
        td = inf;           % set Service Completion Time to infinity
      else                  % If there is at least one Customer in System, and if If last Customer was served successfully
        if lost == false    
          Y = G;            % (G denotes the Service Distribution (Exponential Random Variable with Rate 4))
          td = t + Y;       % Calculate new Service Time of the Customer Presently being served
        end
      end
      
      continue;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Case 3 (Closing Time. Service the Remaining Customers) %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ARRIVAL TIME OF NEXT CUSTOMER  is after  SYSTEM CLOSING TIME or
    % SERVICE COMPLETION TIME of the CUSTOMER PRESENTLY being SERVED  is after  SYSTEM CLOSING TIME and
    % THERE IS ONE or MORE CUSTOMER IN the SYSTEM
    if min(ta, td) > T && n > 0
      t = td;               % Current Time is Service Completion Time of the Customer presently being served
      n = n - 1;            % Number of Customers in the System decreases, because a Customer has been served
      
      lost = tl(1) < td;    % Leaving Times of Currently Waiting Customers is before Service Completion Time of the Customer Presently being served
      tl = tl(2:end);
      
      if lost               % If there is one Customer who left the System before he or she was served
        Nl = Nl + 1;        % Number of Lost Customers increases
      else                  % ELSE (Customer stays in System and waits until he or she is served)
        Nd = Nd + 1;        % Number of Departed Customers increases
      end
      
      if n > 0              % If there is at least one Customer in System
        if lost == false    
          Y = G;            % (G denotes the Service Distribution (Exponential Random Variable with Rate 4))
          td = t + Y;       % Calculate new Service Time of the Customer Presently being served
        end
      end
      
      continue;
    end
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % Case 4 (Closing Time. All Customers are Served) %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % ARRIVAL TIME OF NEXT CUSTOMER  is after  SYSTEM CLOSING TIME or
    % SERVICE COMPLETION TIME of the CUSTOMER PRESENTLY being SERVED  is after  SYSTEM CLOSING TIME and
    % THERE IS NO CUSTOMER IN the SYSTEM
    if min(ta, td) > T && n == 0
      break     % Close the System
    end
    
  end

  
  
  
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Calculate Random Service Time %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % G denotes the Service Distribution (Exponential Random Variable with Rate 4)
  % CALCULATE NEW SERVICE TIME of the CUSTOMER PRESENTLY being SERVED
  function Y = G
    % If X is a Continuous Random Variable Uniformly Distributed over the Interval [0,1], 
    % then Y = -1/Lambda * log(X) has Exponential Distribution with the Parameter Lambda.
    % In our case Lambda is equal to 4
    Y = -1/4 * log(rand);       % Value Range of Y [0, +Inf]
                                % Service of a Customer needs 0 to +Inf of time   
  end



  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Calculate Random Arrival Time of Next Customer %
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  % Homogeneous Poisson Process with Constant Rate (in our case 5)
  % Rate = Lambda that means 'Events per Time Unit'
  function H = HPP(rate)
    H = -log(rand) / rate;      % Value Range of H [0, +Inf]
                                % Arrival Time of Next Customer is between 0 and +Inf
  end
  

 
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Calculate Customer Waiting Time %
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 % Each Customer will only Wait a Random amount of Time, having Distribution F, in Queue, before Leaving the System
  function X = F
    X = 5 * rand;               % Random Variable X Uniformly Distributed over the Interval [0,5]; 
                                % Customer waits between 0 and 5 units of time, before leaving the System
  end
end
