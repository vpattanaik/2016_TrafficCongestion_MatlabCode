function varargout = FindRoad(varargin)
% FINDROAD MATLAB code for FindRoad.fig
%      FINDROAD, by itself, creates a new FINDROAD or raises the existing
%      singleton*.
%
%      H = FINDROAD returns the handle to a new FINDROAD or the handle to
%      the existing singleton*.
%
%      FINDROAD('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FINDROAD.M with the given input arguments.
%
%      FINDROAD('Property','Value',...) creates a new FINDROAD or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FindRoad_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FindRoad_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FindRoad

% Last Modified by GUIDE v2.5 16-May-2016 10:07:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FindRoad_OpeningFcn, ...
                   'gui_OutputFcn',  @FindRoad_OutputFcn, ...
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


% --- Executes just before FindRoad is made visible.
function FindRoad_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FindRoad (see VARARGIN)

% clear image
set(handles.axes1, 'XtickLabel',[], 'YtickLabel',[]);
set(handles.axes2, 'XtickLabel',[], 'YtickLabel',[]);

% Choose default command line output for FindRoad
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FindRoad wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FindRoad_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton_load.
function pushbutton_load_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_load (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.uipanel, 'Title', 'Loaded Map');

LFile = uigetfile('*.jpg');
limg = imread(LFile);
wlimg = imread(['W' LFile]);

%limg = imresize(limg, [640 640]);
%wlimg = imresize(wlimg, [640 640]);

axes(handles.axes1);
imshow(limg);
axes(handles.axes2);
imshow(wlimg);

handles.limg = limg;
handles.wlimg = wlimg;

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton_bw.
function pushbutton_bw_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_bw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.uipanel, 'Title', 'BW Map');
handles.wlimg = rgb2gray(handles.wlimg);
BW = (handles.wlimg >= 251);
BW = bwareaopen(BW, 500);
handles.bw = bw;

axes(handles.axes1);
imshow(handles.limg);
axes(handles.axes2);
imshow(handles.bw);

[M, N] = size(handles.bw);
handles.traf(1: M, 1: N) = 0;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton_sou.
function pushbutton_sou_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_sou (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.uipanel, 'Title', 'Insert Source');


Origin = GetOrigin(  );

axes(handles.axes1); % Select the proper axes
hold on;
plot(Origin(1, 1), Origin(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
hold off;

axes(handles.axes2); % Select the proper axes
hold on;
plot(Origin(1, 1), Origin(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'cyan', 'MarkerEdgeColor', 'cyan');
hold off;

% Choose default command line output for TerrainGenerator
handles.Origin = Origin;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton_des.
function pushbutton_des_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_des (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

set(handles.uipanel, 'Title', 'Insert Destination');

Target = GetTarget(  );

axes(handles.axes1); % Select the proper axes
hold on;
plot(Target(1, 1), Target(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'red', 'MarkerEdgeColor', 'red');
hold off;

axes(handles.axes2); % Select the proper axes
hold on;
plot(Target(1, 1), Target(1, 2), 'Marker', 'v', 'MarkerFaceColor', 'cyan', 'MarkerEdgeColor', 'cyan');
hold off;

% Choose default command line output for TerrainGenerator
handles.Target = Target;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton_instrf.
function pushbutton_instrf_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_instrf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

count = 0;
while count < 2500
    rx = randi([1 M],1,1);
    ry = randi([1 N],1,1);
    
    if handles.bw(rx, ry) == 1
        handles.traf(rx, ry) = handles.traf(rx, ry) + 200;
        
        axes(handles.axes1); % Select the proper axes
        hold on;
        plot(ry, rx, 'b.');
        hold off;

        axes(handles.axes2); % Select the proper axes
        hold on;
        plot(ry, rx, 'm.');
        hold off;
        
        count = count + 1;
    end
end
msgbox('Traffic Added !!!', 'Help', 'help');

% --- Executes on button press in pushbutton_fndpat.
function pushbutton_fndpat_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_fndpat (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Map = uint8(handles.bw);
Map = Map * 255;

Path = FindPath( handles.Origin, handles.Target, Map, handles.traf );

axes(handles.axes1); % Select the proper axes
hold on;
plot(Path(:, 1), Path(:, 2), 'r.');
hold off;

axes(handles.axes2); % Select the proper axes
hold on;
plot(Path(:, 1), Path(:, 2), 'c.');
hold off;

% Choose default command line output for TerrainGenerator
handles.Path = Path;

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in pushbutton_zon.
function pushbutton_zon_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zon (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom on;

% --- Executes on button press in pushbutton_zof.
function pushbutton_zof_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_zof (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

zoom off;
