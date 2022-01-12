function [] = setnd1_3( pos )
%Set the Position of ND1 on Optic Bench 2
global nd1_3 fromgui nd1s_3
if fromgui == 1
    probe_3()
end
if ischar(pos)
    if strcmp(pos,nd1s_3{1})
        fprintf(nd1_3,'pos=1');
        fscanf(nd1_3);
    elseif strcmp(pos,nd1s_3{2})
        fprintf(nd1_3,'pos=2');
        fscanf(nd1_3);
    elseif strcmp(pos,nd1s_3{3})
        fprintf(nd1_3,'pos=3');
        fscanf(nd1_3);
    elseif strcmp(pos,nd1s_3{4})
        fprintf(nd1_3,'pos=4');
        fscanf(nd1_3);
    elseif strcmp(pos,nd1s_3{5})
        fprintf(nd1_3,'pos=5');
        fscanf(nd1_3);
    elseif strcmp(pos,nd1s_3{6})
        fprintf(nd1_3,'pos=6');
        fscanf(nd1_3);
    else
        error('Invalid value for Substage ND.')
    end
elseif isnumeric(pos)
    if pos == nd1s_3{1}
        fprintf(nd1_3,'pos=1');
        fscanf(nd1_3);
    elseif pos == nd1s_3{2}
        fprintf(nd1_3,'pos=2');
        fscanf(nd1_3);
    elseif pos == nd1s_3{3}
        fprintf(nd1_3,'pos=3');
        fscanf(nd1_3);
    elseif pos == nd1s_3{4}
        fprintf(nd1_3,'pos=4');
        fscanf(nd1_3);
    elseif pos == nd1s_3{5}
        fprintf(nd1_3,'pos=5');
        fscanf(nd1_3);
    elseif pos == nd1s_3{6}
        fprintf(nd1_3,'pos=6');
    else
        error('Invalid value for Substage ND.')
    end
else
    error('Invalid input type for Substage ND.')
end
if fromgui == 1
    probe_3()
end
end

