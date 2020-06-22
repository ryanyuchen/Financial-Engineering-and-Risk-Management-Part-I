% Binomial Tree

clc
clear

Spot = 100;                   % Spot Price
K = 110;                      % Strike Price
rf = .02;                    % Annual Risk-free rate
v = .30;                     % Annual Volatility
T = 0.25;                    % Time in months / year
n = 15;                      % Number of steps in future
m = 10;                      % Number of steps in option
OpType = 'C';                % 'C' = Call and 'P' = Put
ExType = 'A';                % 'A' = American and 'E' = European
dt = T/n;                    % Time interval between steps
u = exp(v*sqrt(dt));         % Size of Up step 
d = 1 / u;                   % Size of Down step
c=0.01;                       % Dividend Yield
a = exp((rf-c)*dt);          % Growth Factor
p = (a-d)/(u-d);             % Probability of Up move

for i=1:n+1;
    for j=i:n+1
        S(i,j) = Spot*u^(j-i)*d^(i-1);            % Stock Price
    end
end

% Calculate Future Lattice

Fu(:,m+1)=S(:,m+1);
for j=m:-1:1
    for i=1:j
        Fu(i,j)=p*Fu(i,j+1)+(1-p)*Fu(i+1,j+1);
    end
end

% Calculate Option Price
for i=1:m+1
    if strcmp(OpType,'C')
        Op(i, m+1) = max(Fu(i, m+1) - K, 0);
    else if strcmp(OpType, 'P')
        Op(i, m+1) = max(K - Fu(i, m+1), 0);
        end
    end
end

for j=m:-1:1
    for i=1:j
        if strcmp(OpType, 'C')
            Op(i, j) =  exp(-rf*dt)*(p*Op(i, j+1) + (1-p)*Op(i+1, j+1));
        else
            Op(i, j) =  exp(-rf*dt)*(p*Op(i, j+1) + (1-p)*Op(i+1, j+1));
        end
    end
end
             
Price = Op(1, 1)