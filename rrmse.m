function [ error ] = rrmse( A , B )

error = sqrt( sum(sum( (abs(A)-abs(B)).^2 )) ) / sqrt(sum(sum( abs(A).^2 )) );

end

