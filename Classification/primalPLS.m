function [mu, trainY, W, F] = primalPLS(X,Y,T)

% inputs
% X is an (l x n) matrix whose rows are the training inputs
% Y is (l x m) containing the corresponding output vectors
% T gives the number of iterations to be preformed
%
% outputs
% mu is the mean vectors
% trainY is teh training outputs
% W is the regression coefficients
% F is the features
%
% David R. Hardoon (written some time in 2004)
% davidrh@mac.com
%
% Update 28/01/05: Corrected bug, thanks to Jason Farquhar <jdrf99r@ecs.soton.ac.uk>
%                   code didn't handle multidimensional labels.
%                  Updated feature output
%
% Update 31/01/05: added bug handling

if (nargin ~= 3)
  disp('Incorrect number of inputs');
  help primalPLS;
  mu = 0; trainY = 0; W = 0; F = 0;
  return;
end

mu = mean(X);
X = X - ones(size(X,1),1)*mu; % centering the data
trainY = 0;
l = size(X,1);
YY = Y;

for i=1:T
    YX = Y'*X;
    u(:,i) = YX(1,:)'/norm(YX(1,:));
   
    if size(Y,2) > 1 % only loop if dimension greater than 1
        uold = u(:,i) + 1;
       
        while norm(u(:,i) - uold) > 0.001
            uold = u(:,i);
            tu = YX'*YX*uold;
            u(:,i) = tu/norm(tu);
        end
    end
   
    t = X*u(:,i);
    c(:,i) = Y'*t/(t'*t);
    p(:,i) = X'*t/(t'*t);
   
    trainY = trainY + t*c(:,i)';
    trainerror = norm(YY - trainY,'fro')/sqrt(l);
    X = X - t*p(:,i)';
   
    % compute residual Y = Y - t*c(:,i)';
end

% Regression coefficients for new data
W = u*((p'*u)\c');

% Computing the features
F = u'*inv(u*p');