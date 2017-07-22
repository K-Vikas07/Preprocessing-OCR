function [ x , i] = OMP( y, A, epsilon )

x = zeros(1,80);

r = y; 
index = [];
i = 0;

while(1)
    
  [temp,j] = max ( abs( sum(repmat(r,1,80).* A) ./ (sum(A.*A)) ) );

  index = [index, j];
  clear s;
  s = pinv(A(:,index)) * y;
  clear r;
  r = y - A(:,index)*s;
  i = i+1;
 
if norm(r,'fro') <= epsilon
    break;
end
end

x(index) = s;

end
