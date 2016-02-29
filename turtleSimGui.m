function varargout = turtleSimGui(varargin)
% TURTLESIMGUI MATLAB code for turtleSimGui.fig
%      TURTLESIMGUI, by itself, creates a new TURTLESIMGUI or raises the existing
%      singleton*.
%
%      H = TURTLESIMGUI returns the handle to a new TURTLESIMGUI or the handle to
%      the existing singleton*.
%
%      TURTLESIMGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TURTLESIMGUI.M with the given input arguments.
%
%      TURTLESIMGUI('Property','Value',...) creates a new TURTLESIMGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before turtleSimGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to turtleSimGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help turtleSimGui

% Last Modified by GUIDE v2.5 28-Feb-2016 18:32:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @turtleSimGui_OpeningFcn, ...
    'gui_OutputFcn',  @turtleSimGui_OutputFcn, ...
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


% --- Executes just before turtleSimGui is made visible.
function turtleSimGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to turtleSimGui (see VARARGIN)

% Choose default command line output for turtleSimGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes turtleSimGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = turtleSimGui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in M.
function M_Callback(hObject, eventdata, handles)
% hObject    handle to M (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of M


% --- Executes on button press in W.
function W_Callback(hObject, eventdata, handles)
% hObject    handle to W (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of W


% --- Executes on button press in D.
function D_Callback(hObject, eventdata, handles)
% hObject    handle to D (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of D


% --- Executes on button press in I.
function I_Callback(hObject, eventdata, handles)
% hObject    handle to I (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of I


% --- Executes on button press in V.
function V_Callback(hObject, eventdata, handles)
% hObject    handle to V (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of V


% --- Executes on slider movement.
function simPres_Callback(hObject, eventdata, handles)
% hObject    handle to simPres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function simPres_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simPres (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function aniLen_Callback(hObject, eventdata, handles)
% hObject    handle to aniLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function aniLen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aniLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on key press with focus on simPres and none of its controls.
function simPres_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to simPres (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on slider movement.
function aniSpeed_Callback(hObject, eventdata, handles)
% hObject    handle to aniSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function aniSpeed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aniSpeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on slider movement.
function axisLen_Callback(hObject, eventdata, handles)
% hObject    handle to axisLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function axisLen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axisLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in runAnimation.
function runAnimation_Callback(hObject, eventdata, handles)
% hObject    handle to runAnimation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of runAnimation


% --- Executes on button press in setLevel.
function setLevel_Callback(hObject, eventdata, handles)
% hObject    handle to setLevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of setLevel


% --- Executes on slider movement.
function offsetAxis_Callback(hObject, eventdata, handles)
% hObject    handle to offsetAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider


% --- Executes during object creation, after setting all properties.
function offsetAxis_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offsetAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function inputManualLen_Callback(hObject, eventdata, handles)
% hObject    handle to inputManualLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of inputManualLen as text
%        str2double(get(hObject,'String')) returns contents of inputManualLen as a double


% --- Executes during object creation, after setting all properties.
function inputManualLen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inputManualLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in updateAxis.
function updateAxis_Callback(hObject, eventdata, handles)
% hObject    handle to updateAxis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of updateAxis


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of play


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of next



function ub_Callback(hObject, eventdata, handles)
% hObject    handle to ub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ub as text
%        str2double(get(hObject,'String')) returns contents of ub as a double


% --- Executes during object creation, after setting all properties.
function ub_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ub (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function enter_Callback(hObject, eventdata, handles)
% hObject    handle to enter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of enter as text
%        str2double(get(hObject,'String')) returns contents of enter as a double


% --- Executes during object creation, after setting all properties.
function enter_CreateFcn(hObject, eventdata, handles)
% hObject    handle to enter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lb_Callback(hObject, eventdata, handles)
% hObject    handle to lb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lb as text
%        str2double(get(hObject,'String')) returns contents of lb as a double


% --- Executes during object creation, after setting all properties.
function lb_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function showDate_Callback(hObject, eventdata, handles)
% hObject    handle to showDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of showDate as text
%        str2double(get(hObject,'String')) returns contents of showDate as a double


% --- Executes during object creation, after setting all properties.
function showDate_CreateFcn(hObject, eventdata, handles)
% hObject    handle to showDate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in setTrade.
function setTrade_Callback(hObject, eventdata, handles)
% hObject    handle to setTrade (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of setTrade



function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of exit as text
%        str2double(get(hObject,'String')) returns contents of exit as a double


% --- Executes during object creation, after setting all properties.
function exit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in long.
function long_Callback(hObject, eventdata, handles)
% hObject    handle to long (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of long

if get(handles.long,'Value') == 1
    set(handles.short,'Value',0);
    entered = str2double(get(handles.enter,'String'));
    exit = str2double(get(handles.exit,'String'));
    pr = ((exit-entered)/ entered)*100;
    pr = num2str(pr + str2num(get(handles.pr,'String')));
    set(handles.pr,'String', pr)
end


% --- Executes on button press in short.
function short_Callback(hObject, eventdata, handles)
% hObject    handle to short (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of short
if get(handles.short,'Value') == 1
    set(handles.long,'Value',0);
    entered = str2double(get(handles.enter,'String'));
    exit = str2double(get(handles.exit,'String'));
    pr = ((entered-exit)/ entered)*100;
    pr = num2str(pr + str2num(get(handles.pr,'String')));
    set(handles.pr,'String', pr)
    
end



function pr_Callback(hObject, eventdata, handles)
% hObject    handle to pr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of pr as text
%        str2double(get(hObject,'String')) returns contents of pr as a double


% --- Executes during object creation, after setting all properties.
function pr_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function simPresEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to simPresEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of simPresEditBox as text
%        str2double(get(hObject,'String')) returns contents of simPresEditBox as a double


% --- Executes during object creation, after setting all properties.
function simPresEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to simPresEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function aniLenEditBox_Callback(hObject, eventdata, handles)
% hObject    handle to aniLenEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of aniLenEditBox as text
%        str2double(get(hObject,'String')) returns contents of aniLenEditBox as a double


% --- Executes during object creation, after setting all properties.
function aniLenEditBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to aniLenEditBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in cl.
function cl_Callback(hObject, eventdata, handles)
% hObject    handle to cl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of cl


% --- Executes on button press in op.
function op_Callback(hObject, eventdata, handles)
% hObject    handle to op (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of op



function stopLossPercent_Callback(hObject, eventdata, handles)
% hObject    handle to stopLossPercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of stopLossPercent as text
%        str2double(get(hObject,'String')) returns contents of stopLossPercent as a double


% --- Executes during object creation, after setting all properties.
function stopLossPercent_CreateFcn(hObject, eventdata, handles)
% hObject    handle to stopLossPercent (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in stopLoss.
function stopLoss_Callback(hObject, eventdata, handles)
% hObject    handle to stopLoss (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of stopLoss



function dRunner_Callback(hObject, eventdata, handles)
% hObject    handle to dRunner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dRunner as text
%        str2double(get(hObject,'String')) returns contents of dRunner as a double


% --- Executes during object creation, after setting all properties.
function dRunner_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dRunner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function wRunner_Callback(hObject, eventdata, handles)
% hObject    handle to wRunner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of wRunner as text
%        str2double(get(hObject,'String')) returns contents of wRunner as a double


% --- Executes during object creation, after setting all properties.
function wRunner_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wRunner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mRunner_Callback(hObject, eventdata, handles)
% hObject    handle to mRunner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mRunner as text
%        str2double(get(hObject,'String')) returns contents of mRunner as a double


% --- Executes during object creation, after setting all properties.
function mRunner_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mRunner (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in timer.
function timer_Callback(hObject, eventdata, handles)
% hObject    handle to timer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of timer
