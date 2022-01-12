function varargout = GUI(varargin)
% GUI MATLAB code for GUI.fig
%      GUI, by itself, creates a new GUI or raises the existing
%      singleton*.
%
%      H = GUI returns the handle to a new GUI or the handle to
%      the existing singleton*.
%
%      GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI.M with the given input arguments.
%
%      GUI('Property','Value',...) creates a new GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI

% Last Modified by GUIDE v2.5 27-Jul-2016 19:23:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI (see VARARGIN)

% Choose default command line output for GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
global fromgui wavelengths
fromgui = 1; %this tells the set filter wheel position to also probe filter wheel locations before and after
index_selected = get(hObject,'Value');
if index_selected == 2
    setwl(wavelengths{1});
elseif index_selected == 3
    setwl(wavelengths{2});
elseif index_selected == 4
    setwl(wavelengths{3});
elseif index_selected == 5
    setwl(wavelengths{4});
elseif index_selected == 6
    setwl(wavelengths{5});
elseif index_selected == 7
    setwl(wavelengths{6});
elseif index_selected == 8
    setwl(wavelengths{7});
elseif index_selected == 9
    setwl(wavelengths{8});
elseif index_selected == 10
    setwl(wavelengths{9});
elseif index_selected == 11
    setwl(wavelengths{10});
elseif index_selected == 12
    setwl(wavelengths{11});
end
fromgui = 0;

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global wavelengths
set(hObject,'String',['Wavelength', wavelengths])


% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu2
global fromgui nd1s
fromgui = 1; %this tells the set filter wheel position to also probe filter wheel locations before and after
index_selected = get(hObject,'Value');
if index_selected == 2
    setnd1(nd1s{1});
elseif index_selected == 3
    setnd1(nd1s{2});
elseif index_selected == 4
    setnd1(nd1s{3});
elseif index_selected == 5
    setnd1(nd1s{4});
elseif index_selected == 6
    setnd1(nd1s{5});
elseif index_selected == 7
    setnd1(nd1s{6});
end
fromgui = 0;

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global nd1s
set(hObject,'String',['ND1' nd1s]);


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3
global fromgui nd2s
fromgui = 1; %this tells the set filter wheel position to also probe filter wheel locations before and after
index_selected = get(hObject,'Value');
if index_selected == 2
    setnd2(nd2s{1});
elseif index_selected == 3
    setnd2(nd2s{2});
elseif index_selected == 4
    setnd2(nd2s{3});
elseif index_selected == 5
    setnd2(nd2s{4});
elseif index_selected == 6
    setnd2(nd2s{5});
elseif index_selected == 7
    setnd2(nd2s{6});
end
fromgui = 0;

% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global nd2s
set(hObject,'String',['ND2' nd2s]);

% --- Executes on selection change in popupmenu4.
function popupmenu4_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu4
global fromgui wavelengths_2
fromgui = 1; %this tells the set filter wheel position to also probe filter wheel locations before and after
index_selected = get(hObject,'Value');
if index_selected == 2
    setwl_2(wavelengths_2{1});
elseif index_selected == 3
    setwl_2(wavelengths_2{2});
elseif index_selected == 4
    setwl_2(wavelengths_2{3});
elseif index_selected == 5
    setwl_2(wavelengths_2{4});
elseif index_selected == 6
    setwl_2(wavelengths_2{5});
elseif index_selected == 7
    setwl_2(wavelengths_2{6});
elseif index_selected == 8
    setwl_2(wavelengths_2{7});
elseif index_selected == 9
    setwl_2(wavelengths_2{8});
elseif index_selected == 10
    setwl_2(wavelengths_2{9});
elseif index_selected == 11
    setwl_2(wavelengths_2{10});
elseif index_selected == 12
    setwl_2(wavelengths_2{11})
end
fromgui = 0;

% --- Executes during object creation, after setting all properties.
function popupmenu4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global wavelengths_2
set(hObject,'String',['Wavelength' wavelengths_2]);


% --- Executes on selection change in popupmenu5.
function popupmenu5_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu5
global fromgui nd1s_2
fromgui = 1; %this tells the set filter wheel position to also probe filter wheel locations before and after
index_selected = get(hObject,'Value');
if index_selected == 2
    setnd1_2(nd1s_2{1});
elseif index_selected == 3
    setnd1_2(nd1s_2{2});
elseif index_selected == 4
    setnd1_2(nd1s_2{3});
elseif index_selected == 5
    setnd1_2(nd1s_2{4});
elseif index_selected == 6
    setnd1_2(nd1s_2{5});
elseif index_selected == 7
    setnd1_2(nd1s_2{6});
end
fromgui = 0;

% --- Executes during object creation, after setting all properties.
function popupmenu5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global nd1s_2
set(hObject,'String',['ND1' nd1s_2]);


% --- Executes on selection change in popupmenu6.
function popupmenu6_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu6
global fromgui nd2s_2
fromgui = 1; %this tells the set filter wheel position to also probe filter wheel locations before and after
index_selected = get(hObject,'Value');
if index_selected == 2
    setnd2_2(nd2s_2{1});
elseif index_selected == 3
    setnd2_2(nd2s_2{2});
elseif index_selected == 4
    setnd2_2(nd2s_2{3});
elseif index_selected == 5
    setnd2_2(nd2s_2{4});
elseif index_selected == 6
    setnd2_2(nd2s_2{5});
elseif index_selected == 7
    setnd2_2(nd2s_2{6});
end
fromgui = 0;

% --- Executes during object creation, after setting all properties.
function popupmenu6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
global nd2s_2
set(hObject,'String',['ND2' nd2s_2]);


% --- Executes when selected object is changed in uibuttongroup1.
function uibuttongroup1_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup1 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag')
    case 'ob1on'
        initiatebench1();
        global wavelengths nd1s nd2s
        handles = guidata(GUI);
        set(handles.popupmenu1,'String',['Wavelength' wavelengths]);
        set(handles.popupmenu2,'String',['ND1' nd1s]);
        set(handles.popupmenu3,'String',['ND2' nd2s]);
    case 'ob1off',
        user_response = ConfirmClose('Title','Confirm');
    switch user_response
        case {'No'}
        case {'Yes'}
         closeob1()
    end
end


% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag')
    case 'ob2on'
        initiatebench2();
        global wavelengths_2 nd1s_2 nd2s_2
        handles = guidata(GUI);
        set(handles.popupmenu4,'String',['Wavelength' wavelengths_2]);
        set(handles.popupmenu5,'String',['ND1' nd1s_2]);
        set(handles.popupmenu6,'String',['ND2' nd2s_2]);
    case 'ob2off'
        user_response = ConfirmClose('Title','Confirm');
        switch user_response
            case {'No'}
            case {'Yes'}
                closeob2()
        end
end


% --- Executes during object creation, after setting all properties.
function uibuttongroup1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



% --- Executes when uibuttongroup2 is resized.
function uibuttongroup2_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function uibuttongroup2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function ob1on_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ob1on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global nd1
if isempty(nd1)
    set(hObject,'Value',0);
else
    set(hObject,'Value',1);
end


% --- Executes during object creation, after setting all properties.
function ob1off_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ob1off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global nd1
if isempty(nd1)
    set(hObject,'Value',1);
else
    set(hObject,'Value',0);
end


% --- Executes during object creation, after setting all properties.
function ob2on_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ob2on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global nd1_2
if isempty(nd1_2)
    set(hObject,'Value',0);
else
    set(hObject,'Value',1);
end


% --- Executes during object creation, after setting all properties.
function ob2off_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ob2off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
global nd1_2
if isempty(nd1_2)
    set(hObject,'Value',1);
else
    set(hObject,'Value',0);
end

% --- Executes on button press in ob1on
function ob1on_Callback(hObject, eventdata, handles)
% hObject    handle to ob1off (see GCB)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ob1on



% --- Executes on button press in ob1off.
function ob1off_Callback(hObject, eventdata, handles)
% hObject    handle to ob1off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ob1off


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over popupmenu1.
function popupmenu1_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in popupmenu7.
function popupmenu7_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu7
global fromgui nd1s_3
fromgui = 1; %this tells the set filter wheel position to also probe filter wheel locations before and after
index_selected = get(hObject,'Value');
if index_selected == 2
    setnd1_3(nd1s_3{1});
elseif index_selected == 3
    setnd1_3(nd1s_3{2});
elseif index_selected == 4
    setnd1_3(nd1s_3{3});
elseif index_selected == 5
    setnd1_3(nd1s_3{4});
elseif index_selected == 6
    setnd1_3(nd1s_3{5});
elseif index_selected == 7
    setnd1_3(nd1s_3{6});
end
fromgui = 0;

% --- Executes during object creation, after setting all properties.
function popupmenu7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in uibuttongroup6.
function uibuttongroup6_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup6 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'Tag')
    case 'substageON'
        initiatebench3();
        global nd1s_3
        handles = guidata(GUI);
        set(handles.popupmenu7,'String',['ND1' nd1s_3]);
    case 'substageOFF'
        user_response = ConfirmClose('Title','Confirm');
        switch user_response
            case {'No'}
            case {'Yes'}
                closeob3()
        end
end


% --- Executes during object creation, after setting all properties.
function uibuttongroup6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uibuttongroup6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
