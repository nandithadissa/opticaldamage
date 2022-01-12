%test script to control the ND filters
nd1 = serial('COM5','BaudRate', 115200, 'Terminator', 'CR')
fopen(nd1)
fprintf(nd1,'pos=2')
fscanf(nd1)
fprintf(nd1,'pos?')
a=fscanf(nd1)
a
fclose(nd1)
delete(nd1)