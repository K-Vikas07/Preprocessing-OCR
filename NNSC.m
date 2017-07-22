function [ W , H , oldobj , objHistory] = NNSC ( Y , initW , initH , lambda , maxiter )

% Initialize W and H
W = initW;
H = initH;

m  = size(Y,1);
p = size(initW,2);
n = size(Y,2);

flag = true; 

% Rescaling each atom of dictionary to have unit norm
W = bsxfun( @rdivide , W , sqrt(sum(abs(W).^2,1)) ); %W1./repmat(sum(W1.^2,1),size(W1,2),1)

% Setting initial step size and finding initial value of objective function
mu = 1e-6;
objHistory = 0;
oldobj = sum(sum( - Y .* log(W*H) )) + sum(sum( W*H ))   + lambda * sum(H(:));
iter = 0; successiter = 0;

% Iterating in order to minimize objective function value
while flag && iter < maxiter
    
    flag2 = true;
    iter = iter + 1
    
    % Updating dictionary
    WH = W*H;
%     newW = W - mu * ( -(Y./(W*H))*H' + repmat(sum(H,2)',m,1) ); 
    newW = W - mu * ( -(Y./(W*H))*H' + ones(m,n)*H' ); 
    newW = max(newW,0); 
    
    colnorm = sqrt(sum(abs(newW).^2,1));
    if any(colnorm == 0)
        flag2 = false; % If flag2 is set to false, updates will not be made and mu will be halved
    else
        newW = bsxfun( @rdivide , newW , colnorm );
    end
        
    % Updating coefficients
    newH = H - mu * ( -W'*(Y./(W*H)) + W'*ones(m,n) + lambda);
%     newH = H - mu * ( -W'*(Y./(W*H)) + repmat(sum(W,1)',1,n) + lambda);
    newH = max(newH,0);
    
    newobj = sum(sum( - Y .* log(newW*newH) )) + sum(sum( newW*newH ))   + lambda * sum(newH(:));
        
    rel_change = ( oldobj - newobj ) * 100 / oldobj; 
    if ( (rel_change <= 0.01) && (rel_change > 0) && flag2) 
        flag = false; 
    end
    if newobj <= oldobj && flag2
        % Updating W and H (persist)
        H = newH; W = newW; 
        mu = mu + 0.1 * mu;
        successiter = successiter + 1;
        objHistory(successiter) = newobj; 
        oldobj = newobj; 
    else
        mu = mu/2; 
    end
    if mu < 1e-12
        break;
    end
    
end

if flag == false
    disp('convergence criteria reached!!');
end

end

