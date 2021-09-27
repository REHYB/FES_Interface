function output=limit(input,L,U)
output=input;
for i=1:length(input)
    if input(i)>U
        output(i)=U;
    elseif input(i)<L
        output(i)=L;
    else
        output(i)=input(i);
    end
end
end
%%