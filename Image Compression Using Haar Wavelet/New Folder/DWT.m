function varargout = DWT(varargin)
% DWT M-file for DWT.fig
%      DWT, by itself, creates a new DWT or raises the existing
%      singleton*.
%
%      H = DWT returns the handle to a new DWT or the handle to
%      the existing singleton*.
%
%      DWT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DWT.M with the given input arguments.
%
%      DWT('Property','Value',...) creates a new DWT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before DWT_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to DWT_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help DWT

% Last Modified by GUIDE v2.5 05-Jan-2011 18:52:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @DWT_OpeningFcn, ...
    'gui_OutputFcn',  @DWT_OutputFcn, ...
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


% --- Executes just before DWT is made visible.
function DWT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to DWT (see VARARGIN)

% Choose default command line output for DWT
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes DWT wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = DWT_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function declevel_Callback(hObject, eventdata, handles)
% hObject    handle to declevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of declevel as text
%        str2double(get(hObject,'String')) returns contents of declevel as a double


% --- Executes during object creation, after setting all properties.
function declevel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to declevel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clc;
global image_in;
scales = str2num(get(handles.declevel, 'string'))

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define constants
	h_phi=[1/sqrt(2),1/sqrt(2)];
	h_psi=[-1/sqrt(2),1/sqrt(2)];
	N=size(image_in,1);	%Width
	M=size(image_in,2);	%Height
   %scales=2;
   quantifier=128;
   
   phi_in=image_in;		% starts off the recursion
      
   % perform the reduction {scales} times
   % "q" is halved after every iteration
	for j = 1:scales
   	q=2^j;
% this first loop filters and downsamples the columns of the input
      % image, as per figure 7.22 in the textbook. For some reason, MATLAB's
      % convolution routine always adds a trailing zero, hence the extra lines.
		for ii = 1:N/(0.5*q)
   		psi_n(1:M/(q),ii)=resample(filter(h_psi,1,phi_in(1:(M/(0.5*q)),ii)),1,2,0);
         phi_n(1:M/(q),ii)=resample(filter(h_phi,1,phi_in(1:(M/(0.5*q)),ii)),1,2,0);
         
         %pause
		end
      
      % this second loop filters and downsamples the rows of the two inputs
      % calcuated above, also as per figure 7.22. Wpsi_d,Wpsi_v,Wpsi_h and Wphi
      % represent the componants of the image, and are assembled meaningfully below.
      for ii = 1:M/(q)
         Wpsi_v(ii,1:N/(q))=resample(filter(h_phi,1,psi_n(ii,1:(N/(0.5*q)))),1,2,0);
   		Wpsi_h(ii,1:N/(q))=resample(filter(h_psi,1,phi_n(ii,1:(N/(0.5*q)))),1,2,0);
   		Wpsi_d(ii,1:N/(q))=resample(filter(h_psi,1,psi_n(ii,1:(N/(0.5*q)))),1,2,0);
         Wphi(ii,1:N/(q))=resample(filter(h_phi,1,phi_n(ii,1:(N/(0.5*q)))),1,2,0); 
       
		end
      
      % this portion arranges the componants in the proper places in the final 
      % transformed image. The scaled approximation is placed upper left, 
      % vertical lower left, etc, etc.
		phi_in=0.5*Wphi;
		image_fwt(1:M/q,1:N/q)=phi_in;
      image_fwt(1:M/q,(N/q)+1:(N/(0.5*q)))=(Wpsi_v./quantifier).*quantifier; 
      image_fwt((M/q)+1:(M/(0.5*q)),1:N/q)=(Wpsi_h./quantifier).*quantifier; 
      image_fwt((M/q)+1:(M/(0.5*q)),(N/q)+1:(N/(0.5*q)))=(Wpsi_d./quantifier).*quantifier; 
        
   	% clear certain variables after each iteration, so we don't use old values.
   	clear temp_psi_n psi_n temp_phi_n phi_n;
   	clear temp_Wpsi_d Wpsi_d temp_Wpsi_v Wpsi_v temp_Wpsi_h Wpsi_h temp_Wphi Wphi;
	end


	 %draws really nifty lines on the output image
	 %make sure to use original image_fwt for IWDT below
	image_fwt_disp=image_fwt;
	N=size(image_in,1);	%Width
	M=size(image_in,2);	%Height
   
   for jj=1:scales
   	image_fwt_disp((M/2),1:N)=255;
		image_fwt_disp(1:M,(N/2))=255;
   	M=M/2;
   	N=N/2;
	end

	 % plot the resulting Image
	%figure(2)
     figure(2)
	imshow(image_fwt_disp,[])
	truesize(2)
   title('Discrete Wavelet Transform Using Haar Basis Functions');
   
   
   
   % define constants  
	h_phi=[1/sqrt(2),1/sqrt(2)];
	h_psi=[1/sqrt(2),-1/sqrt(2)];
	N=size(image_in,1);	%Width
	M=size(image_in,2);	%Height
   %scales=3;
   Wphi=image_fwt(1:M/(2^scales),1:N/(2^scales));
   
   %j=3;
   
  	for j = scales:-1:1
   	q=2^j;
   
   	Wpsi_h=image_fwt(1:M/q,(N/q)+1:(N/(0.5*q)));
   	Wpsi_v=image_fwt((M/q)+1:(M/(0.5*q)),1:N/q);
		Wpsi_d=image_fwt((M/q)+1:(M/(0.5*q)),(N/q)+1:(N/(0.5*q)));
   
        testn = 2;
   	for ii = 1:M/q
         Wpsi_d_temp(ii,1:N/(0.5*q))=filter(h_psi,1,upsample(Wpsi_d(ii,1:N/q),testn));
         Wpsi_v_temp(ii,1:N/(0.5*q))=filter(h_phi,1,upsample(Wpsi_v(ii,1:N/q),testn));
         Wpsi_h_temp(ii,1:N/(0.5*q))=filter(h_psi,1,upsample(Wpsi_h(ii,1:N/q),testn));
         Wphi_temp(ii,1:N/(0.5*q))=filter(h_phi,1,upsample(Wphi(ii,1:N/q),testn));
      end
      
      for ii = 1:N/(0.5*q)
         sum=(Wpsi_d_temp(1:N/q,ii))+(Wpsi_v_temp(1:N/q,ii));
         Wphi_psi(1:M/(0.5*q),ii)=filter(h_psi,1,transpose(upsample(sum, testn)));
         sum=(Wpsi_h_temp(1:N/q,ii))+(Wphi_temp(1:N/q,ii));
         Wphi_phi(1:M/(0.5*q),ii)=filter(h_phi,1,transpose(upsample(sum, testn)));

      end
      
      	Wphi=Wphi_psi(1:M/(0.5*q),1:N/(0.5*q))+Wphi_phi(1:M/(0.5*q),1:N/(0.5*q));
	end         
 
  %axes(handles.axes2);
  
  figure(3)
  imshow(Wphi,[])
   truesize(3)
   title('Image Recovered from IDWT')
   
   % compute error from the dct
   A=(image_in-Wphi).^2;
   A_sum=0;
   for ii = 1:M
      for jj = 1:N
         A_sum=A_sum+A(ii,jj);
      end
   end
   image_wavelet_error=((1/(M*N))*A_sum)^0.5, 
   image_wavelet_snr=snr(image_in,Wphi),


   


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global image_in;
[imgfile, imgpath] = uigetfile( ...
    {'*.bmp;*.jpeg;*.png;*.jpg', 'Supported Image Files (*.bmp, *.jpeg, *.png)';
    '*.*',  'All Files)'})

ofile = [imgpath imgfile]
orgimg = imread(ofile);
image_in=double(imread(ofile));
axes(handles.axes1);
imshow(orgimg,[]);

