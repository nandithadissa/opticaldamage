function [] = setnd1( pos )
%Set the Position of ND1 on Optic Bench 1
%   
global nd1 fromgui
if fromgui == 1
    probe()
end
global nd1s
if ischar(pos)
    if strcmpi(pos,nd1s{1})
        fprintf(nd1,'pos=1');
        fscanf(nd1);
    elseif strcmpi(pos,nd1s{2})
        fprintf(nd1,'pos=2');
        fscanf(nd1);
    elseif strcmpi(pos,nd1s{3})
        fprintf(nd1,'pos=3');
        fscanf(nd1);
    elseif strcmpi(pos,nd1s{4})
        fprintf(nd1,'pos=4');
        fscanf(nd1);
    elseif strcmpi(pos,nd1s{5})
        fprintf(nd1,'pos=5');
        fscanf(nd1);
    elseif strcmpi(pos,nd1s{6})
        fprintf(nd1,'pos=6');
        fscanf(nd1);
    else
        error('Invalid value for nd1.')
    end
elseif isnumeric(pos)
    if pos == nd1s{1}
        fprintf(nd1,'pos=1');
        fscanf(nd1);
    elseif pos == nd1s{2}
        fprintf(nd1,'pos=2');
        fscanf(nd1);
    elseif pos == nd1s{3}
        fprintf(nd1,'pos=3');
        fscanf(nd1);
    elseif pos == nd1s{4}
        fprintf(nd1,'pos=4');
        fscanf(nd1);
    elseif pos == nd1s{5}
        fprintf(nd1,'pos=5');
        fscanf(nd1);
    elseif pos == nd1s{6}
        fprintf(nd1,'pos=6');
        fscanf(nd1);
    else
        error('Invalid value for nd1.')
    end
else
    error('Invalid type for nd1.')
end
if fromgui == 1
    probe()
end
end

