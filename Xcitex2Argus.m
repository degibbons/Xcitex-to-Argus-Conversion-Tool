function [] = Xcitex2Argus()

S.fh = figure('units','pixels','position',[330,180,860,520],'name',...
    'Xcitex to Argus Conversion Tool','resize','off');
S.tx(1)=uicontrol('style','text','unit','pixels','background',...
    get(S.fh,'color'),'position',[190 350 150 150], 'fontsize',10,'string',...
    'You have ''000'' features.Please enter the starting and ending features below.');
S.tx(2)=uicontrol('style','text','unit','pixels','backg',...
    get(S.fh,'color'),'position',[10 150 150 150],'fontsize',10,'string',...
    'Enter the offsets in a vector.');
S.tx(3)=uicontrol('style','text','unit','pixels','backg',...
    get(S.fh,'color'),'position',[10 30 180 150],'fontsize',10,'string',...
    'Enter the screen resolution width and height.');
S.tx(4)=uicontrol('style','text','unit','pixels','backg',...
    get(S.fh,'color'),'fontsize',10,'position',[220 105 250 150],'string',...
    'Enter new file name here.');
S.tx(5)=uicontrol('style','text','unit','pixels','background',...
    get(S.fh,'color'),'position',[750 350 100 150], 'fontsize',10,'string',...
    'Is this a Plumb Bob?');
S.tx(6)=uicontrol('style','text','unit','pixels','background',...
    get(S.fh,'color'),'position',[750 280 100 150], 'fontsize',10,'string',...
    '(Check if yes)');
S.tx(7)=uicontrol('style','text','unit','pixels','background',...
    get(S.fh,'color'),'position',[750 230 100 150],'fontsize',10,'string',...
    'If the above is checked, do you want to invert the two points?');
S.tx(8)=uicontrol('style','text','unit','pixels','background',...
    get(S.fh,'color'),'position',[750 115 100 150],'fontsize',10,'string',...
    '(Check if yes)');
S.tx(9)=uicontrol('style','text','unit','pixels','background',...
    get(S.fh,'color'),'position',[750 60 100 150],'fontsize',10,'string',...
    'Flip Y-Axis? (Check for Yes)');
S.cb(1)=uicontrol('style','checkbox','unit','pixels','position',[790 435 50 20]);
S.cb(2)=uicontrol('style','checkbox','unit','pixels','position',[790 270 50 20]);
S.cb(3)=uicontrol('style','checkbox','unit','pixels','position',[790 140 50 20]);
S.pb(1)=uicontrol('style','pushbutton','unit','pixels','position',...
    [10 350 150 150],'fontsize',12,'fontweight','bold','string',...
    'Select Files','BackgroundColor','b');
S.pb(2)=uicontrol('style','pushbutton','unit','pixels','position',[230 10 230 100],...
    'fontsize',12,'fontweight','bold','BackgroundColor','y','string','Start Over/Reset');
S.pb(3)=uicontrol('style','pushbutton','unit','pixels','position',[480 140 250 120],...
    'fontsize',12,'fontweight','bold','BackgroundColor','g','string','Run','Interruptible','on');
S.pb(4)=uicontrol('style','pushbutton','unit','pixels','position',[480 10 250 120],...
    'fontsize',12,'fontweight','bold','BackgroundColor','r','string','Stop');
S.pb(5)=uicontrol('style','pushbutton','unit','pixels','position',[10 10 200 60],...
    'fontsize',12,'fontweight','bold','BackgroundColor','m','string','Click Here For Help');
S.lb=uicontrol('style','listbox','unit','pixels','position',[370 280 350 200],...
    'string','Selected files go here');
S.ed(1)=uicontrol('style','edit','unit','pixels','position',[190 350 150 50],...
    'string','Beginning Feature');
S.ed(2)=uicontrol('style','edit','unit','pixels','position',[190 280 150 50],...
    'string','Ending Feature');
S.ed(3)=uicontrol('style','edit','unit','pixels','position',[10 200 200 50],...
    'string','Offset Vector');
S.ed(4)=uicontrol('style','edit','unit','pixels','position',[10 85 200 50],'string',...
    'Screen Resolution');
S.ed(5)=uicontrol('style','edit','unit','pixels','position',[230 175 230 50],'string',...
    'New File Name');
S.bg=uibuttongroup('units','pixels','position',[230 115 230 50],'title','Format:');
S.rd(1)=uicontrol(S.bg,'style','radiobutton','unit','pixels','position',[40 8 80 30],'string','Argus');
S.rd(2)=uicontrol(S.bg,'style','radiobutton','unit','pixels','position',[130 8 80 30],'string','DLTdv');
set(S.tx(1),'callback',{@tx_call,S})
set(S.pb(1),'callback',{@pb_call1,S})
set(S.pb(2),'callback',{@pb_call2,S})
set(S.pb(4),'callback',{@pb_call4,S})
set(S.pb(5),'callback',{@pb_call5,S})
global stopvar;
stopvar=false;

    function [] = pb_call1(varargin)
        S=varargin{3};
        [FileName,PathName,~]=uigetfile('*.xlsx','MultiSelect','on');
        if PathName==0
        else
            cd(PathName);
            cams=length(FileName);
            raw_Data=xlsread(FileName{1});
            raw_DataTrimmed=raw_Data(15:end,:);
            featureNumber=((size(raw_Data,2)-2)/2);
            featureNumberS=num2str(featureNumber);
            E=get(S.tx(1),'string');
            fLength=length(featureNumberS);
            E(13-fLength+1:13)=featureNumberS;
            S.raw_DataTrimmed=raw_DataTrimmed;
            S.cams=cams;
            S.FileName=FileName;
            set(S.tx(1),'string',E);
            set(S.lb,'string',FileName);
            set(S.pb(3),'callback',{@pb_call3,S})
        end
    end

    function [] = pb_call2(varargin)
        set(S.lb,'string','Selected files go here');
        set(S.lb,'value',1);
        set(S.ed(1),'string','Beginning Feature');
        set(S.ed(2),'string','Ending Feature');
        set(S.ed(3),'string','Offset Vector');
        set(S.ed(4),'string','Screen Resolution');
        set(S.ed(5),'string','New File Name');
        set(S.tx(1),'string','You have ''000'' features.Please enter the starting and ending features below.');
        set(S.cb(1),'value',0);
        set(S.cb(2),'value',0);
        set(S.cb(3),'value',0);
        set(S.rd(1),'value',1);
        set(S.rd(2),'value',0)
        stopvar=false;
    end

    function [] = pb_call3(varargin)
        S=varargin{3};
        E1=get(S.ed(1),'string');
        E2=get(S.ed(2),'string');
        E3=get(S.ed(3),'string');
        E4=get(S.ed(4),'string');
        E5=get(S.ed(5),'string');
        rdV=get(S.rd,'value');
        startFeature=str2num(E1);
        endFeature=str2num(E2); %#ok<*ST2NM>
        ftsNumber=endFeature-startFeature+1;
        IV=get(S.cb(3),'value');
        if IV==0 && rdV{1,1}==1 && rdV{2,1}==0
            newFileName=strcat(E5,'.csv');
        else
            newFileName=E5;
        end
        offsets=str2num(E3);
        offsets1=offsets;
        resolution=str2num(E4);
        resolution(1,2)=resolution(1,2)+1;
        dataColumns=endFeature*2*S.cams;
        endColumns=(startFeature-1)*2*S.cams;
        totColumns=dataColumns-endColumns;
        names=cell(1,totColumns);
        tempNew_Data=cell(1,S.cams);
        Lengths=zeros(1,S.cams);
        for i=1:S.cams
            if stopvar==true
                return
            end
            tempRaw_Data=xlsread(S.FileName{i});
            tempRaw_Data=tempRaw_Data(15:end,:);
            tempNew_Data{1,i}=tempRaw_Data;
            tempLength=size(tempRaw_Data);
            Lengths(1,i)=tempLength(1,1);
        end
        m=min(Lengths);
        for j=1:S.cams
            if stopvar==true
                return
            end
            if Lengths(1,j)>=m
                tempFix=tempNew_Data{1,j};
                tempFix((m+1):end,:)=[];
                tempNew_Data{1,j}=tempFix;
            end
        end
        newData=nan(size(tempFix,1)+1,totColumns);
        for a=1:S.cams
            if stopvar==true
                return
            end
            if offsets1(a)>0 || offsets1(a)<0
                offsets(a)=-offsets1(a);
                offsetfix=tempNew_Data{1,a};
                offsetfix=circshift(offsetfix,offsets(a),1);
                s=size(offsetfix);
                if offsets1(a)>0
                    offsetfix(((s(1)-abs(offsets1(a)))+1):end,:)=-1;
                elseif offsets1(a)<0
                    offsetfix(1:abs(offsets1(a)),:)=-1;
                end
                tempNew_Data{1,a}=offsetfix;
            end
        end
        if rdV{1,1}==1 && rdV{2,1}==0
            i=1;
            while i<=totColumns
                for j=startFeature:endFeature
                    for k=1:S.cams
                        if stopvar==true
                            return
                        end
                        newData(2:end,i)=tempNew_Data{1,k}(:,(j*2+1));
                        newData(2:end,i+1)=tempNew_Data{1,k}(:,(j*2+2));
                        names{1,i}=char(strcat('Track' ,{' '},num2str(j),'_cam_',num2str(k),'_x'));
                        names{1,i+1}=char(strcat('Track' ,{' '},num2str(j),'_cam_',num2str(k),'_y'));
                        i=i+2;
                    end
                end
            end
        elseif rdV{2,1}==1 && rdV{1,1}==0
            i=1;
            while i<=totColumns
                for j=startFeature:endFeature
                    for k=1:S.cams
                        if stopvar==true
                            return
                        end
                        newData(2:end,i)=tempNew_Data{1,k}(:,(j*2+1));
                        newData(2:end,i+1)=tempNew_Data{1,k}(:,(j*2+2));
                        names{1,i}=char(strcat('pt',num2str(j),'_cam',num2str(k),'_x'));
                        names{1,i+1}=char(strcat('pt',num2str(j),'_cam',num2str(k),'_y'));
                        i=i+2;
                    end
                end
            end
        end
        PB=get(S.cb(1),'value');
        p=1;
        PBnames=cell(1,S.cams*2);
        if PB==1
            while p<=(S.cams*2)
                for q=1:S.cams
                    PBnames{1,p}=char(strcat('pt1_cam',num2str(q),'_X'));
                    PBnames{1,p+1}=char(strcat('pt1_cam',num2str(q),'_Y'));
                    p=p+2;
                end
            end
        end
        newData(newData==-1)=NaN;
        newData(1,:)=[];
        for i=2:2:totColumns
            if stopvar==true
                return
            end
            tempYflip=newData(:,i);
            yLength=length(tempYflip);
            for j=1:yLength
                if stopvar==true
                    return
                end
                tempYflip(j,1)=resolution(1,2)-tempYflip(j,1);
            end
            newData(:,i)=tempYflip;
        end
        PBinv=get(S.cb(2),'value');
        if PB==1
            if stopvar==true
                return
            end
            tempPBdata0=zeros(1,S.cams*4);
            tempPBdata1=zeros(1,S.cams*2);
            tempPBdata2=zeros(1,S.cams*2);
            PBdata=zeros(2,S.cams*2);
            PBsize=size(newData);
            for r=1:PBsize(1,2)
                PBval= ~isnan(newData(:,r));
                tempPBdata0(1,r)=newData(PBval,r);
            end
            tempPBdata1(1,:)=tempPBdata0(1,1:end/2);
            tempPBdata2(1,:)=tempPBdata0(1,(end/2)+1:end);
            if PBinv==1
                PBdata(1,:)=tempPBdata2;
                PBdata(2,:)=tempPBdata1;
            else
                PBdata(1,:)=tempPBdata1;
                PBdata(2,:)=tempPBdata2;
            end
            newData=PBdata;
            names=PBnames;
        end
        IVsize=size(newData);
        if IV==1
            tempCell=cell(1,S.cams);
            IVnamesCell=cell(1,S.cams);
            for y=1:S.cams
                if stopvar==true
                    return
                end
                IVnames=cell(1,totColumns/S.cams);
                ab=1;
                while ab<=totColumns/S.cams
                    if stopvar==true
                        return
                    end
                    for v=1:(totColumns/(S.cams*2))
                        IVnames{1,ab}=char(strcat('Track' ,{' '},num2str(v),'_cam_',num2str(y),'_x'));
                        IVnames{1,ab+1}=char(strcat('Track' ,{' '},num2str(v),'_cam_',num2str(y),'_y'));
                        ab=ab+2;
                    end
                end
                tempIVdata=zeros(IVsize(1,1),(totColumns/S.cams));
                w=y*2-1;
                while w<=totColumns
                    for z=1:2:totColumns/S.cams
                        if stopvar==true
                            return
                        end
                        tempIVdata(:,z)=newData(:,w);
                        tempIVdata(:,z+1)=newData(:,w+1);
                        w=w+(S.cams*2);
                    end
                end
                tempCell{1,y}=tempIVdata;
                IVnamesCell{1,y}=IVnames;
            end
        end
        if IV==1 && rdV{1,1}==1 && rdV{2,1}==0 && PB==0
            IVfilenames=cell(1,S.cams);
            for x=1:S.cams
                if stopvar==true
                    return
                end
                IVfilenames{1,x}=char(strcat(newFileName,'_cam_',num2str(x),'.csv'));
                fid=fopen(IVfilenames{1,x},'w');
                fprintf(fid,'%s,', IVnamesCell{1,x}{1,1:end});
                fclose(fid);
                dlmwrite(IVfilenames{1,x},tempCell{1,x},'roffset',1,'-append');
            end
        elseif IV==0 && rdV{1,1}==1 && rdV{2,1}==0
            fid=fopen(newFileName,'w');
            fprintf(fid,'%s,', names{1,1:end}) ;
            fclose(fid);
            dlmwrite(newFileName,newData,'roffset',1,'-append');
            emptycell=cell(1,IVsize(1,2));
            xrange=char(strcat('A',num2str(IVsize(1,1)+2),':',{64+IVsize(1,2)},num2str(IVsize(1,1)+2)));
            xlswrite(newFileName,emptycell,xrange);
        elseif IV==00 && rdV{1,1}==0 && rdV{2,1}==1 && PB==0
            rdVnames=cell(1,4);
            rdVnames{1,1}=char(strcat(newFileName,'-xypts.csv'));
            rdVnames{1,2}=char(strcat(newFileName,'-offsets.csv'));
            rdVnames{1,3}=char(strcat(newFileName,'-xyzpts.csv'));
            rdVnames{1,4}=char(strcat(newFileName,'-xyzres.csv'));
            dataSize=size(newData);
            rdvHeaders=cell(1,3);
            rdvHeaders{1,1}=cell(1,S.cams);
            for a=1:S.cams
                rdvHeaders{1,1}{1,a}=char(strcat('cam',num2str(a),'_offset'));
            end
            rdvHeaders{1,2}=cell(1,ftsNumber*3);
            de=1;
            while de<=ftsNumber*3
                for b=1:ftsNumber
                    rdvHeaders{1,2}{1,de}=char(strcat('pt',num2str(b),'_X'));
                    rdvHeaders{1,2}{1,de+1}=char(strcat('pt',num2str(b),'_Y'));
                    rdvHeaders{1,2}{1,de+2}=char(strcat('pt',num2str(b),'_Z'));
                    de=de+3;
                end
            end
            rdvHeaders{1,3}=cell(1,ftsNumber);
            for c=1:ftsNumber
                rdvHeaders{1,3}{1,c}=char(strcat('pt',num2str(c),'_dltres'));
            end
            rdA=zeros(dataSize(1,1),S.cams);
            rdA(1,:)=offsets1;
            rdA(end,:)=offsets1;
            rdB=NaN(dataSize(1,1),ftsNumber*3);
            rdC=NaN(dataSize(1,1),ftsNumber);
            fid=fopen(rdVnames{1,1},'w');
            fprintf(fid,'%s,', names{1,1:end}) ;
            fclose(fid);
            dlmwrite(rdVnames{1,1},newData,'roffset',1,'-append');
            fid2=fopen(rdVnames{1,2},'w');
            fprintf(fid2,'%s,',rdvHeaders{1,1}{1,1:end});
            fclose(fid2);
            dlmwrite(rdVnames{1,2},rdA,'roffset',1,'-append');
            fid3=fopen(rdVnames{1,3},'w');
            fprintf(fid3,'%s,',rdvHeaders{1,2}{1,1:end});
            fclose(fid3);
            dlmwrite(rdVnames{1,3},rdB,'roffset',1,'-append');
            fid4=fopen(rdVnames{1,4},'w');
            fprintf(fid4,'%s,',rdvHeaders{1,3}{1,1:end});
            fclose(fid4);
            dlmwrite(rdVnames{1,4},rdC,'roffset',1,'-append');
        else
            error('Improper Formatting. Please re-evaluate inputs and try again. For further help, click Help Box!')
        end
        fclose all;
        
        msgbox('File Conversion is Done!')
    end

    function [] = pb_call4(varargin)
        stopvar=true;
    end


%%%%%%%%%%%%%%%%  Help Box  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function [] = pb_call5(varargin)
        SCR = get(0,'Screensize');
        H.fh=figure('numbertitle','off',...
            'menubar','none',...
            'units','pixels',...
            'position',[SCR(3)/2-200 ,SCR(4)/2-200 , 430, 500],...
            'name','Help Box',...
            'resize','off');
        H.tg(1) = uicontrol('style','toggle',...
            'units','pixels',...
            'position',[5 455 80 40],...
            'string','General',...
            'val',1);
        H.tg(2) = uicontrol('style','toggle',...
            'units','pixels',...
            'position',[85 455 80 40],...
            'string','Select File',...
            'value',0,...
            'enable','on');
        H.tg(3) = uicontrol('style','toggle',...
            'units','pixels',...
            'position',[165 455 80 40],...
            'string','Inputs',...
            'value',0,...
            'enable','on');
        H.tg(4) = uicontrol('style','toggle',...
            'units','pixels',...
            'position',[245 455 90 40],...
            'string','Run/Stop/Reset',...
            'value',0,...
            'enable','on');
        H.tg(5) = uicontrol('style','toggle',...
            'units','pixels',...
            'position',[335 455 90 40],...
            'string','CheckBox',...
            'value',0,...
            'enable','on');
        H.tg(6) = uicontrol('style','toggle',...
            'units','pixels',...
            'position',[5 415 80 40],...
            'string','Format',...
            'value',0,...
            'enable','on');
        H.tx(1) = uicontrol('style','text',...
            'units','pixels',...
            'position',[20 20 360 395],...
            'visible','on',...
            'string',{' ','This program is designed to convert single camera'...
            'feature tracking files from Xcitex software'...
            '(such as ProAnalyst) format into a ',...
            'format usable by Argus. This code compiles multiple'...
            'cameras and puts them into a single file.',' ',...
            'Program designed by Dr. Nathan '...
            'Thompson. Program edited by Daniel Gibbons.',' ','If there are '...
            'any questions not answered by this guide, please send any inquiries to'...
            'danegibbons@gmail.com or nthomp03@nyit.edu'...
            'or call (631)456-7733.'},...
            'fontsize',10,'fontweight','bold');
        H.tx(2) = uicontrol('style','text',...
            'units','pixels',...
            'position',[20 20 360 395],...
            'visible','off',...
            'string',{' ','The Select Files button opens up a window to select all'...
            'of the files that the user wants to use. This should be the'...
            'FIRST step in using this program. Upon navigating to the'...
            'directory containing the selected files, the user should'...
            'select ALL files corresponding to different cameras from'...
            'the same experiment. After hitting open, the selected'...
            'file names should appear in the listbox to the right. If an'...
            'error has been made, the user may hit the'...
            'Start Over/Reset button to clear the listbox and re-hit'...
            'Select Files to re-select the desired files.'},...
            'fontsize',10,'fontweight','bold');
        H.tx(3) = uicontrol('style','text',...
            'units','pixels',...
            'position',[20 20 360 395],...
            'visible','off',...
            'string',{' ','The text at the top of the program displays an ''X'' for the'...
            'number of features present before selecting files. After'...
            'the user selects their files, the ''X'' will change to the'...
            ' amount of features detected in the data files.'...
            'The user may input below the two features they''d like to'...
            'start and end with respectively. The starting feature'...
            'must be 1 or greater, and less than or equal to the'...
            'ending feature. The ending feature must be less than or'...
            'equal to the total amount of features detected and may'...
            'not be smaller than the starting feature.',...
            ' ','The offset vector is a vector containing the offset frames'...
            'for each camera file selected. i.e. if camera 3 of 5 is off'...
            'by 2 frames, the corresponding offset vector would look like, '...
            '[0 0 2 0 0].'...
            '(Note: The user does not have to include [ ] in their vector.)',...
            ' ','The screen resolution should include two values corresponding'...
            'to the screen resolution of the camera used for each file.'...
            'i.e. [2704 1520] for GoPro Hero4 Black 2.7K'...
            '(Note: The user does not have to include [ ] in their vector.)'...
            ' ','The user may put a new file name for the merged and cleaned'...
            'output file. The name will be merged with .csv so the output file'...
            'is in comma-separated values format. The resulting file should'...
            'form in the same directory as the original data files.'...
            'i.e. NewDataFile1'},...
            'fontsize',8,'fontweight','bold');
        H.tx(4) = uicontrol('style','text',...
            'units','pixels',...
            'position',[20 20 360 395],...
            'visible','off',...
            'string',{' ','The Run button takes in all inputs typed by the user'...
            'and the selected files and spits out an Argus-usable file'...
            'where the selected range of features is analyzed, the'...
            'offsets for each camera are fixed, and the new file is'...
            'labeled as desired.', ' ','The Stop button should only be used to stop the Run'...
            'process if the action takes too long. The Stop button'...
            'does nothing else other than stop the Run function and'...
            'return control to the entire figure.',' ',...
            'The Reset button only resets the displayed files and'...
            'typed inputs. After hitting Reset, the Select Files'...
            'button should be selected again, and inputs should be'...
            'retyped. Reset should be hit after hitting Stop or before'...
            'hitting Select Files. '},...
            'fontsize',10,'fontweight','bold');
        H.tx(5) = uicontrol('style','text',...
            'units','pixels',...
            'position',[20 20 360 395],...
            'visible','off',...
            'string',{' ','The first two check boxes to the right are used only'...
            'when analyzing PlumbBob files. These individual excel files'...
            'should only have one point for each feature mapped out over all frames. To clarify, '...
            'if i have 4 cameras mapping a two-headed wand with a feature/point,'...
            'at each end, there should be only 16 data values total: ',' ',...
            '2 [features] * 2 [points per feature] (x & y) * 4 [# of cameras]=16 [total data values]'...
            ' ','The resulting file will have one row for each feature and two columns per camera'...
            '(one for each X value and one for each Y value).', ' ','The second check box'...
            'mearly switches the order of the features for axis orientation.',' ',...
            'Offsets for this analysis can be put as 0 for each camera.',' ',...
            'The last checkbox converts all files into their own individual ',...
            'result files. The program assumes the files are input in',...
            'ascending order of cameras, and will ',...
            'place identifying camera ID text to the end of each new file name.',' ','i.e. TestFile1_cam_1, TestFile1_cam_2, etc.'}',...
            'fontsize',8,'fontweight','bold');
        H.tx(6)= uicontrol('style','text',...
            'units','pixels',...
            'position',[20 20 360 395],...
            'visible','off',...
            'string',{' ','The Format toggle buttons switch the output file format',...
            ' from Argus to DLTdv. The DLTdv option will spit out 4 files instead',...
            ' of 1 like the Argus selection does. The following files have additions',...
            ' to their file names according to their use'...
            '(i.e. -offsets, -xypts, -xyzpts, and -xyzres)',' ',...
            '-xypts is the original data file with slightly different headers',...
            'the rest of the files are for use with the MATLAB DLT programs.',...
            ' ','Take note, the DLTdv format should NOT be used with the PlumbBob,',...
            'or Individual boxes checked!'},...
            'fontsize',10,'fontweight','bold');
        set(H.tg(:),{'callback'},{{@tg_call,H}})
        
        function [] = tg_call(varargin)
            [h,H] = varargin{[1,3]};
            
            if get(h,'val')==0
                set(h,'val',1)
            end
            switch h
                case H.tg(1)
                    set(H.tg([2,3,4,5,6]),{'val'},{0})
                    set(H.tx(1),{'visible'},{'on'})
                    set([H.tx(2),H.tx(3),H.tx(4),H.tx(5),H.tx(6)],{'visible'},{'off'})
                case H.tg(2)
                    set(H.tg([1,3,4,5,6]),{'val'},{0})
                    set(H.tx(2),{'visible'},{'on'})
                    set([H.tx(1),H.tx(3),H.tx(4),H.tx(5),H.tx(6)],{'visible'},{'off'})
                case H.tg(3)
                    set(H.tg([1,2,4,5,6]),'val',0)
                    set(H.tx(3),{'visible'},{'on'})
                    set([H.tx(1),H.tx(2),H.tx(4),H.tx(5),H.tx(6)],{'visible'},{'off'})
                case H.tg(4)
                    set(H.tg([1,2,3,5,6]),{'val'},{0})
                    set(H.tx(4),'visible','on')
                    set([H.tx(1),H.tx(2),H.tx(3),H.tx(5),H.tx(6)],{'visible'},{'off'})
                case H.tg(5)
                    set(H.tg([1,2,3,4,6]),{'val'},{0})
                    set(H.tx(5),'visible','on')
                    set([H.tx(1),H.tx(2),H.tx(3),H.tx(4),H.tx(6)],{'visible'},{'off'})
                case H.tg(6)
                    set(H.tg([1,2,3,4,5]),{'val'},{0})
                    set(H.tx(6),'visible','on')
                    set([H.tx(1),H.tx(2),H.tx(3),H.tx(4),H.tx(5)],{'visible'},{'off'})
            end
        end
        
    end
end
