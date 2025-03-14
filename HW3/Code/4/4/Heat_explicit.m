function diffusion_output = Heat_explicit(w, alpha)
w = imresize(w, [256 256]);
k = 1;
h = 1;

lambda = (alpha^2)*(k/(h^2));

[m n] = size(w);

% A matrix form Ax=B linear system
A = zeros(m,m);

% this gen_vec would be rotated and used to populate the matrix A
gen_vec = zeros(1,m);
gen_vec(1,1) = lambda;
gen_vec(1,2) = (1-2*lambda);
gen_vec(1,3) = lambda;

%filling in values of A matrix
for i=2:m
    A(i,:) = gen_vec;
    gen_vec = circshift(gen_vec,[1 1]);    
end
A(1,1) = (1-2*lambda);
A(1,2) = (lambda);

%making the top-right and bottom-left corners null
A(1:2,n-1:n) = 0;
A(m-1:m,1:2) = 0;

fprintf('size of w: %d\n',[size(w)]);
fprintf('size of w: %d\n',[size(A)]);
w_j_1 = w;
j=1;
figure
for i=1:200 %for each iteration
    %multiplication by A on both sides results in diffences in both x and y
    %directions
    w_j = (A * w_j_1) * A; 
    %old values = new values
    w_j_1 = w_j;
    if i==10
        diffusion_output = w_j;
    end
    %outputing the results at different i values
    if((i==10)||(i==50)||(i==100)||(i==200))
        subplot(2,2,j)
        imshow((w_j));
        imwrite(uint8(w_j),strcat('heat-exp-synimgn2',int2str(j),'.bmp'));
        title('Solution to Heat Equation using Explicit Euler Method');
        xlabel(strcat('at t = ',int2str(i),[', Alpha=', num2str(alpha)]));        
        j=j+1;
    end
end
