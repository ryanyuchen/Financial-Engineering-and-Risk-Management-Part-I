% Binomial Tree

clc
clear

Spot = 100;                   % Spot Price
K = 110;                      % Strike Price
rf = .02;                    % Annual Risk-free rate
v = .30;                     % Annual Volatility
T = 0.25;                    % Time in months / year
n = 15;                      % Number of steps
OpType = 'P';                % 'C' = Call and 'P' = Put
ExType = 'E';                % 'A' = American and 'E' = European
dt = T/n;                    % Time interval between steps
u = exp(v*sqrt(dt));         % Size of Up step 
d = 1 / u;                   % Size of Down step
c=0.01;                      % Dividend Yield
a = exp((rf-c)*dt);          % Growth Factor
p = (a-d)/(u-d);             % Probability of Up move

for i=1:n+1;
    for j=i:n+1
        S(i,j) = Spot*u^(j-i)*d^(i-1);            % Stock Price
    end
end

% Calculate Terminal Price for Calls and Puts

for i=1:n+1
    if strcmp(OpType,'C')
        Op(i, n+1) = max(S(i, n+1) - K, 0);
    else if strcmp(OpType, 'P')
        Op(i, n+1) = max(K - S(i, n+1), 0);
        end
    end
end

% Calculate Remaining entries for Calls and Puts

for j=n:-1:1
    for i=1:j
        if strcmp(ExType, 'A')
            if strcmp(OpType, 'C')
                Op(i, j) = max(S(i, j) - K, exp(-rf*dt)*(p*Op(i, j+1) + (1-p)*Op(i+1, j+1)));
            else
                Op(i, j) = max(K - S(i, j), exp(-rf*dt)*(p*Op(i, j+1) + (1-p)*Op(i+1, j+1)));
            end
        else if strcmp(ExType, 'E')
            Op(i, j) = exp(-rf*dt)*(p*Op(i, j+1) + (1-p)*Op(i+1, j+1));
            end
        end
    end
end
    
Price = Op(1, 1)