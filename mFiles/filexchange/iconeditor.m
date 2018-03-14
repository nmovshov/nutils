function iconeditor(x,y,p)
% iconeditor  icon editor for creating and editing icons and small images.
% iconeditor create and edit icons or mouse cursors in either standard or custom sizes
% 
% usage:
% iconeditor(x,y,pixel)
%     x - horizontal size (16 as deault)
%     y - horizontal size (16 as deault)
%     pixel - size of each dot (13 as deafult)
% 
% iconeditor
%     same as iconeditor(16,16,16)
%
% iconeditor(img)
%     img - 3D-RGB image matrix
%
% iconeditor(img,pixel)
%     img - RGB image matrix
%     pixel - size of each pixel (13 as deault)
%
% author:  Elmar Tarajan [MCommander@gmx.de]
% version: v1.4.2
% last update: 17-Mar-2008

switch nargin
   case 0
      H.x = 16;
      H.y = 16;
      H.p = 13;
   case 1
      cdata = x;
      H.x = size(cdata,2);
      H.y = size(cdata,1);
      H.p = round(14-max(H.x,H.y)/16);
   case 2
      if size(x,3)~=3
         H.x = x;
         H.y = y;
         H.p = round(14-max(H.x,H.y)/16);
      else
         cdata = x;
         H.x = size(cdata,2);
         H.y = size(cdata,1);
         H.p = y;
      end% if
   case 3
      H.x = x;
      H.y = y;
      H.p = max(min(p,20),6);
end% switch
%
if H.x*H.y >= 4096
   switch questdlg({'The image is too big.' 'Continue anyway?'},'Warning...','Yes', 'No', 'No');
     case 'No', return
   end% switch
end% if
%
if exist('cdata','var')
   switch class(cdata)
      case 'uint8' , cdata = double(cdata)./255;
      case 'uint16', cdata = double(cdata)./65535;
   end% switch
end% if
%
% main figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ssz = get(0,'ScreenSize');
width  = max(max(H.x*H.p+14,222),(H.x+9)*5+14)+20-3;
height = H.y*H.p+105+H.y+16;
location = (ssz(3:4)-[width height])/2;
%
H.gcf = figure('menubar','none', ....
                'resize','off', ...
                'NumberTitle','off', ...
                'Name','IconEditor v1.4.2', ...
                'units','pixel', ...
                'position',[location width height], ...
                'dock','off', ...
                'renderer','opengl', ...
                'visible','off');
%
% uimenu's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H.menu(1) = uimenu(H.gcf,'Label','Icon');
H.menu(2) = uimenu(H.menu(1),'Label','&New');
H.menu(3) = uimenu(H.menu(1),'Label','Convert to grayscale','separator','on');
H.menu(4) = uimenu(H.menu(1),'Label','Export to Workspace','separator','on');
H.menu(5) = uimenu(H.menu(1),'Label','Export to M-Code via clipboard');
H.menu(6) = uimenu(H.menu(1),'Label','Info','Separator','on');
H.menu(7) = uimenu(H.menu(1),'Label','Quit');
drawnow
%
% paint area
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H.nan = [.75 .74 .70 ; .83 .81 .78 ; .90 .89 .85 ; .83 .81 .78];
pos = [(width-H.x*H.p-11)/2 58 H.x*H.p+14 H.y*H.p+37];
H.panel = uipanel('units','pixel','Position',pos, ...
              'BorderType','beveledin','Backgroundcolor',[.45 .45 .45]);
H.gca = axes('parent',H.panel,'units','pixel','position',[6 22 H.x*H.p H.y*H.p], ...
                 'Xlim',[0 H.x*H.p],'Ylim',[0 H.y*H.p],'visible','off');
% paint patch
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xx = H.p*reshape(repmat([0:H.x-1;1:H.x;1:H.x;0:H.x-1],H.y,1),4,H.x*H.y);
yy = H.p*repmat([(H.y-1):-1:0;(H.y-1):-1:0;H.y:-1:1;H.y:-1:1],1,H.x);
clr = repmat(reshape(H.nan,[4,1,3]),1,H.x*H.y);
H.draw = patch(xx,yy,clr,'EdgeColor',[.45 .45 .45],'Parent',H.gca);
%
% icon's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
img = icondata;
for i=1:5
   H.iconaxes(i) = axes('parent',H.panel);
   H.icon(i) = image(uint8(repmat(img(:,:,i),[1 1 3])));
   set(H.iconaxes(i),'units','pixel','position',[7+(i-1)*21 4 15 15],'visible','off', ...
                     'XTick',[],'XColor',[.9 .9 .9],'YTick',[],'YColor',[.9 .9 .9])
end% for
set(H.iconaxes(1),'Visible','on')
set(H.icon,'buttondownfcn',{@iconclick,H})
set(H.icon(end),'buttondownfcn',{@grid_callback,H.draw})
for i=6:7
   tmp1 = axes('parent',H.panel);
   H.icon(i)= image(228-uint8(repmat(img(:,:,i),[1 1 3])),'UserData',uint8(repmat(img(:,:,i),[1 1 3])));
   set(tmp1,'units','pixel','position',[H.x*H.p-129+(i-1)*20 4 15 15],'visible','off')
end% for
%
cfg.parent = H.panel;
cfg.style = 'text';
cfg.enable = 'inactive';
cfg.fontsize = 8;
cfg.backgroundcolor = [.45 .45 .45];
cfg.foregroundcolor = [.9 .9 .9];
cfg.horizontalalignment = 'left';
H.pos = uicontrol(cfg,'Position',[6 H.y*H.p+22 40 12]);
cfg.horizontalalignment = 'right';
H.rgb = uicontrol(cfg,'Position',[H.x*H.p-101 H.y*H.p+22 105 12]);
% H.undo_info = uicontrol(cfg,'Position',[H.x*H.p-30 2 15 12], ...
%    'foregroundcolor',[.3 .3 .3],'enable','inactive','String','0|0');
%
% colormap panel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos(1) = (width-222+3)/2;
tmp = uipanel('units','pixel','Position',[pos(1) 10 222 44], ...
                 'BorderType','beveledin','Backgroundcolor',[.8 .8 .8]);
H.color = uicontrol('parent',tmp,'style','text', ...
                    'backgroundcolor',[0 0 0], 'userData',[0 0 0], ...
                    'units','pixel','position',[189 9 24 24], ...
                    'Enable','off','buttondownfcn',{@changecolor});
H.cmap = axes('parent',tmp,'units','pixel','position',[5 4 16*11 3*11], ...
                  'Xlim',[0 16*11],'Ylim',[0 3*11],'visible','off');
%
% colormap path
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
H.textnan = text(186,16,'NaN','FontSize',7,'color',[.3 .3 .3],'visible','off');
xx = 11*reshape(repmat([0:16-1;1:16;1:16;0:16-1],3,1),4,16*3);
yy = 11*repmat([(3-1):-1:0;(3-1):-1:0;3:-1:1;3:-1:1],1,16);
cmenu = uicontextmenu('Parent',H.gcf);
tmp = patch(xx,yy,NaN,'uicontextmenu',cmenu);
set(tmp,'EdgeColor',[.8 .8 .8],'FaceVertexCData',reshape(repmat(standard_colormap',4,1),[3 192])','ButtonDownFcn',{@pickcolor,H})
for i={'standard' 'gray' 'jet' 'hsv' 'hot' 'cool' 'copper' 'pink' 'bone'}
   uimenu(cmenu,'Label',char(i),'Callback',{@changecolormap,tmp,cmenu})
end% for

% preview buttons
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pos = [(width-((H.x+9)*5+14)+3)/2 H.y*H.p+91+8 (H.x+9)*5+14 H.y+17];
tmp = uipanel('units','pixel','Position',pos,'BorderType','beveledin','Backgroundcolor',[.8 .8 .8]);
for i=1:5
   cmenu = uicontextmenu('Parent',H.gcf);
   H.push(i) = uicontrol('parent',tmp,'style','pushbutton', ...
      'cdata',nan(H.y,H.x,3),'backgroundcolor',[.8 .8 .8], ...
      'units','pixel','position',[(i-1)*(H.x+10)+6 4 H.x+7 H.y+7], ...
      'uicontextmenu',cmenu);
   uimenu(cmenu,'Callback',{@setpushbutton,H.push(i)},'Label','set string')   
   uimenu(cmenu,'Callback',{@setpushbutton,H.push(i)},'Label','set foregroundcolor')   
   uimenu(cmenu,'Callback',{@setpushbutton,H.push(i)},'Label','set backgroundcolor')
end% for
pos = get(H.push,'position');
set(H.push,'Callback',{@preview,H,pos})
preview(H.push(1),[],H,pos)
%
% show image if exist
if exist('cdata','var')
   set(H.push(1),'cdata',cdata)
   cdata = repmat(reshape(cdata,[1 H.x*H.y 3]),4,1);
   id = isnan(cdata(1,:,1));
   cdata(:,id,:) = repmat(reshape(H.nan,[4,1,3]),1,sum(id));
   set(H.draw,'cdata',cdata)
end% if
%
% prepare "undo"-feature
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
setappdata(H.gcf,'undoid',1)
setappdata(H.gcf,'undo',{get(H.draw,'FaceVertexCData')});
%
% prepare main callbacks
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(H.menu,'Callback',{@uimenu_callback,H})
set(H.draw,'buttondownfcn',{@mouse_down,H})
set(H.gcf,'WindowButtonMotionFcn',{@mouse_move,H,[],0},'visible','on','HandleVisibility','callback')





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function uimenu_callback(obj,cnc,H)
%-------------------------------------------------------------------------------
cdata = get(H.draw,'CData');
cdata(1,any(cdata(:,:,1)-repmat(cdata(1,:,1),4,1)),:) = NaN;
cdata = reshape(cdata(1,:,:),[H.y H.x 3]);
switch get(obj,'Label')
   case '&New'
      switch questdlg('This action will delete the current image.','new icon','OK', 'cancel', 'cancel');
         case 'OK'
            set(H.draw,'CData',repmat(reshape(H.nan,[4 1 3]),[1 H.x*H.y 1]));
            % 
            undo_feature('reset',[],H)
      end% switch
      %
   case 'Convert to grayscale'
      cdata = repmat(0.2989 * cdata(:,:,1) + ...
         0.5870 * cdata(:,:,2) + ...
         0.1140 * cdata(:,:,3),[1 1 3]);
      %
      set(H.push(1),'cdata',cdata)
      cdata = repmat(reshape(cdata,[1 H.x*H.y 3]),4,1);
      id = isnan(cdata(1,:,1));
      cdata(:,id,:) = repmat(reshape(H.nan,[4,1,3]),1,sum(id));
      set(H.draw,'cdata',cdata)
      %
      undo_feature('add',[],H)
      %
   case 'Export to Workspace'
      tmp = inputdlg('variable name','export to workspace',1,{'cdata'});
      while ~isvarname(char(tmp))&&~isempty(tmp)
         tmp = inputdlg('variable name is invalid!','export to workspace',1,tmp);
      end% while
      if ~isempty(tmp)
         assignin('base',char(tmp),cdata);
      end% if
      %
   case 'Export to M-Code via clipboard'
      out = [];
      for i=1:3
         out = [out sprintf('cdata(:,:,%d) = [ ...\n\t',i)];
         out = [out sprintf([repmat('%3.0f ',1,H.x) '; ...\n\t'],cdata(:,:,i)'*255)];
         out = [out sprintf(']/255;\n')];
      end% for
      clipboard('copy',out)
      %
   case 'Info'
      answer = questdlg({'IconEditor v1.4.2' ...
         '(c) 2008 by Elmar Tarajan [MCommander@gmx.de]'}, ...
         'about...','look for updates','Bug found?','OK','OK');
      switch answer
         case 'look for updates'
            web(['http://www.mathworks.com/matlabcentral/fileexchange/' ...
               'loadAuthor.do?objectId=936824&objectType=author'],'-browser');
         case 'Bug found?'
            web(['mailto:MCommander@gmx.de?subject=IconEditor%20v1.4.2-BUG:' ...
               '[Description]-[ReproductionSteps]-[Suggestion' ...
               '(if%20possible)]-[MATLAB%20v' strrep(version,' ','%20') ']']);
         case 'OK',
      end % switch
      %
   case 'Quit'
      delete(H.gcf)
      %
end% switch
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mouse_down(obj,cnc,H)
%-------------------------------------------------------------------------------
a = get(H.gcf,'SelectionType');
b = find(strcmp(get(H.iconaxes,'visible'),'on'));
if strcmp(a,'normal') && b==1
   % PAINT
   switch get(H.color,'visible')
      case 'on'  ; color = repmat(get(H.color,'userdata'),4,1);
      case 'off' ; color = get(H.color,'userdata');
   end% switch
   %
elseif strcmp(a,'normal') && b==2
   % CLEAR
   color = H.nan;
   %
elseif (strcmp(a,'normal') && b==3) || strcmp(a,'extend')
   % PICKER
   pos = floor(get(H.gca,'CurrentPoint')/H.p);
   id = (pos(1)*H.y+(H.y-pos(3)-1))*4+1;
   clr = get(obj,'FaceVertexCData');
   if all(all(clr(id:id+3,:)-clr([id id id id],:)==0,2))
      set(H.color,'visible','on','backgroundcolor',clr(id,:),'userdata',clr(id,:))
      set(H.textnan,'visible','off')
   else
      set(H.color,'visible','off','userdata',H.nan)
      set(H.textnan,'visible','on')
   end% if
   set(H.iconaxes,'visible','off')
   set(H.iconaxes(1),'visible','on')
   return
   %
elseif (strcmp(a,'normal') && b==4)
   % FILL
   pos = floor(get(H.gca,'CurrentPoint')/H.p);
   pos = pos(1)*H.y+(H.y+1)-pos(3)-1;
   img = get(H.draw,'cdata');
   clr1 = img(:,pos,:);
   switch get(H.color,'visible')
      case 'on'  ; tmp = repmat(get(H.color,'userdata'),4,1);
      case 'off' ; tmp = get(H.color,'userdata');
   end% switch
   clr2 = reshape(tmp,[4,1,3]);
   %
   if ~isequal(clr1,clr2)
      set(gco,'Cdata',recfill(img,pos,H.y,clr1,clr2))
      %
      undo_feature('add',[],H)
   end% if
   return
   %
elseif strcmp(a,'alt')
   % CLEAR (right mouse button)
   if find(strcmp(get(H.iconaxes,'visible'),'on'))==4
      pos = floor(get(H.gca,'CurrentPoint')/H.p);
      pos = pos(1)*H.y+(H.y+1)-pos(3)-1;
      img = get(H.draw,'cdata');
      clr1 = img(:,pos,:);
      clr2 = reshape(H.nan,[4 1 3]);
      if ~isequal(clr1,clr2)
         set(gco,'Cdata',recfill(img,pos,H.y,clr1,clr2))
         undo_feature('add',[],H)
      end% if
      return
   end% if
   color = H.nan;
   set(H.iconaxes,'visible','off')
   set(H.iconaxes(1),'visible','on')
   %
else
   return
end% if
% %
set(gcf,'WindowButtonMotionFcn',{@mouse_move,H,color,1},'WindowButtonUpFcn',{@mouse_up,H})
mouse_move([],[],H,color,1)

  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mouse_move(fig,cnc,H,color,flag)
%-------------------------------------------------------------------------------
pos = floor(get(H.gca,'CurrentPoint')/H.p);
id = (pos(1)*H.y+(H.y-pos(3)-1))*4+1;
clr = get(H.draw,'FaceVertexCData');
if ~(H.x-pos(1)<1 || H.y-pos(3)<1 || pos(1)<0 || pos(3)<0)
   if flag
      clr(id:id+3,:) = color;
      set(H.draw,'FaceVertexCData',clr);
      set(H.rgb,'string',sprintf('R:%03.0f  G:%03.0f  B:%03.0f',255*color(1,:)))      
   else
      if any(clr(id:id+3,:)-H.nan)
         set(H.rgb,'string',sprintf('R:%03.0f  G:%03.0f  B:%03.0f',255*clr(id:id,:)))
      else
         set(H.rgb,'string','NaN')
      end
   end% if
   set(H.pos,'string',sprintf('%02d,%02d',pos(1)+1,pos(3)+1))
else
   set([H.rgb H.pos],'string','')
end% if
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function mouse_up(fig,cnc,H) 
%-------------------------------------------------------------------------------
set(fig,'WindowButtonMotionFcn',{@mouse_move,H,[],0},'WindowButtonUpFcn','')
undo_feature('add',[],H)
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function img = recfill(img,pos,step,clr1,clr2)
%-------------------------------------------------------------------------------
id = floor((pos-1)/step)*step+1:pos;
tmp1 = max(id(find(~all(all(img(:,id,:) == repmat(clr1,[1 length(id) 1]),3)))+1));
if isempty(tmp1)
   tmp1 = id(1);
end% if
%
id = pos:ceil(pos/step)*step;
tmp2 = min(id(find(~all(all(img(:,id,:) == repmat(clr1,[1 length(id) 1]),3)))-1));
if isempty(tmp2)
   tmp2 = id(end);
end% if
%
img(:,tmp1:tmp2,:) = repmat(clr2,[1 length(tmp1:tmp2)]);
%
for n=tmp1:tmp2
   %
   if n-step>0 && all(all(img(:,n-step,:)==clr1,3))
      img = recfill(img,n-step,step,clr1,clr2);
   end
   %
   if n+step<=size(img,2) && all(all(img(:,n+step,:) == clr1,3))
      img = recfill(img,n+step,step,clr1,clr2);
   end% if
   %
end% for
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function undo_feature(obj,cnc,H,step)
%-------------------------------------------------------------------------------
undo = getappdata(H.gcf,'undo');
undoid = getappdata(H.gcf,'undoid');
if ~ishandle(obj)
   switch obj
      case 'reset'
         setappdata(H.gcf,'undoid',1)
         setappdata(H.gcf,'undo',{get(H.draw,'FaceVertexCData')});
         set(H.icon(6),'CData',228-get(H.icon(6),'UserData'),'buttondownfcn','')
         set(H.icon(7),'CData',228-get(H.icon(7),'UserData'),'buttondownfcn','')
         %
      case 'add'
         undo = undo(1:undoid);
         undo{undoid+1} = get(H.draw,'FaceVertexCData');
         setappdata(H.gcf,'undo',undo);
         setappdata(H.gcf,'undoid',undoid+1);
         %
         set(H.icon(6),'CData',get(H.icon(6),'UserData'),'buttondownfcn',{@undo_feature,H,-1});
         set(H.icon(7),'CData',228-get(H.icon(7),'UserData'),'buttondownfcn','')
         %
   end% switch
else
   undoid = min(max(undoid+step,1),length(undo));
   set(H.draw,'FaceVertexCData',undo{undoid})
   setappdata(H.gcf,'undoid',undoid);

   if undoid<length(undo)
      set(H.icon(7),'CData',get(H.icon(7),'UserData'),'buttondownfcn',{@undo_feature,H,1});
   else
      set(H.icon(7),'CData',228-get(H.icon(7),'UserData'),'buttondownfcn','')
   end% if

   if undoid>1
      set(H.icon(6),'CData',get(H.icon(6),'UserData'),'buttondownfcn',{@undo_feature,H,-1});
   else
      set(H.icon(6),'CData',228-get(H.icon(6),'UserData'),'buttondownfcn','')
   end% if
   %
end% if
% set(H.undo_info,'string',sprintf('%d|%d',undoid-1,length(undo)-(undoid)))
%
% update preview
cdata = get(H.draw,'CData');
cdata(1,any(cdata(:,:,1)-repmat(cdata(1,:,1),4,1)),:) = NaN;
set(findobj(H.push,'Tag','current'),'cdata',reshape(cdata(1,:,:),[H.y H.x 3]));
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function preview(obj,cnc,H,pos)
%-------------------------------------------------------------------------------
if ~strcmp(get(obj,'Tag'),'current')
   set(H.push,{'position'},pos)
   % set current preview
   set(H.push,'Tag','')
   pos = get(obj,'position');
   set(obj,'Tag','current','position',pos+[-2 -2 4 4])
else
   % refresh "draw" with preview
   cdata = get(obj,'CData');
   cdata = repmat(reshape(cdata,[1 H.x*H.y 3]),4,1);
   id = isnan(cdata(1,:,1));
   cdata(:,id,:) = repmat(reshape(H.nan,[4,1,3]),1,sum(id));
   set(H.draw,'cdata',cdata)
   %
   undo_feature('reset',[],H)
end% if
drawnow
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function grid_callback(obj,cnc,h)
%-------------------------------------------------------------------------------
switch class(get(h,'EdgeColor'))
   case 'double'
      set(h,'EdgeColor','none')
   case 'char'
      set(h,'EdgeColor',[.45 .45 .45])
end% switch
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function changecolormap(obj,cnc,h,cmenu)
%-------------------------------------------------------------------------------
set(h,'FaceVertexCData',reshape(repmat(eval([get(obj,'Label') '(48)'])',4,1),[3 192])');
set(get(cmenu,'children'),'Checked','off')
set(obj,'Checked','on')
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function changecolor(obj,cnc)
%-------------------------------------------------------------------------------
clr = uisetcolor(get(obj,'backgroundcolor'));
set(obj,'backgroundcolor',clr,'userdata',clr);
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function setpushbutton(obj,cnc,H)
%-------------------------------------------------------------------------------
switch get(obj,'Label')
   case 'set string'
      set(H,'string',char(inputdlg('string:','asdas',1,{get(H,'String')})));
      %
   case 'set foregroundcolor'
      set(H,'foregroundcolor',uisetcolor(get(H,'foregroundcolor')))
      %
   case 'set backgroundcolor'
      set(H,'backgroundcolor',uisetcolor(get(H,'backgroundcolor')))
      %
end% switch
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function pickcolor(obj,cnc,H)
%-------------------------------------------------------------------------------
if strcmp('normal',get(gcf,'SelectionType'))
   pos = round((get(H.cmap,'CurrentPoint')-5.5)/11);
   clr = get(obj,'Cdata');
   set(H.color,'visible','on','backgroundcolor',clr(1,pos(1)*3+3-pos(3),:),'userdata',clr(1,pos(1)*3+3-pos(3),:))
   set(H.textnan,'visible','off')
   if find(strcmp(get(H.iconaxes,'visible'),'on'))~=4
      set(H.iconaxes,'visible','off')
      set(H.iconaxes(1),'visible','on')
   end% if
end% if
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function clr = standard_colormap(cnc)
%-------------------------------------------------------------------------------
clr = [ 0   0   0  ; .5  .5   0  ; .5  .5  .25 ; ...
       .5  .5  .5  ; .25 .5  .5  ; .75 .75 .75 ; ...
       .25  0  .25 ;  1   1   1  ; .25  0   0  ; ...
       .5  .25  0  ;  0  .25  0  ;  0  .25 .25 ; ...
        0   0  .5  ;  0   0  .25 ; .25  0  .25 ; ...
       .25  0  .5  ; .5   0   0  ;  1  .5   0  ; ...
        0  .5   0  ;  0  .5  .25 ;  0   0   1  ; ...
        0   0  .75 ; .5   0  .5  ; .5   0   1  ; ...
       .5  .25 .25 ;  1  .5  .25 ;  0   1   0  ; ...
        0  .5  .5  ;  0  .25 .5  ; .5  .5   1  ; ...
       .5   0  .25 ;  1   0  .5  ;  1   0   0  ; ...
        1   1   0  ; .5   1   0  ;  0   1  .25 ; ...
        0   1   1  ;  0  .5  .75 ; .5  .5  .75 ; ...
        1   0   1  ;  1  .5  .5  ;  1   1  .5  ; ...
       .5   1  .5  ;  0   1  .5  ; .5   1   1  ; ...
        0  .5   1  ;  1  .5  .75 ;  1  .5   1  ];
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
function iconclick(obj,cnc,H)
%-------------------------------------------------------------------------------
set(H.iconaxes,'visible','off')
set(get(obj,'parent'),'visible','on')
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function img = icondata
%-------------------------------------------------------------------------------
%
% PENCIL
img(:,:,1) = ...
 [ 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114
   114 114 114 114 114 114 114 114 114 114 118 165 147 144 152 120
   114 114 114 114 114 114 114 114 114 114 168 165 225 227 149 125
   114 114 114 114 114 114 114 114 114 186 212 225 227 227 219 144
   114 114 114 114 114 114 114 114 186 237 226 174 207 207 219 146
   114 114 114 114 114 114 114 186 237 244 217 207 157 171 145 114
   114 114 114 114 114 114 186 237 244 220 214 238 180 143 114 114
   114 114 114 114 114 186 237 244 220 214 238 180 143 114 114 114
   114 114 114 114 144 237 244 220 214 238 180 143 114 114 114 114
   114 114 114 137 230 244 220 214 238 180 143 114 114 114 114 114
   114 113 137 203 169 220 214 238 180 143 114 114 114 114 114 114
   114 109 225 231 125 153 196 156 131 114 114 114 114 114 114 114
   114 109 227 170 152 103  96 118 114 114 114 114 114 114 114 114
   114  66 156 207 207 139 118 114 114 114 114 114 114 114 114 114
   114  64  66 105 118 131 114 114 114 114 114 114 114 114 114 114
   114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 ];
%
% CLEAR
img(:,:,2) = ...
 [ 114 114 114 114 114 114 114 114 110  97  86 107 114 114 114 114
   114 114 114 114 114 114 114  95  81  74  86  86  80 109 114 114
   114 114 114 114 114 114  98  80  86 102 100 128 129  92 109 114
   114 114 114 114 114 103  93  90  91  89 100 109 151 148  82 114
   114 114 114 114 121 144  95  95  91 102 111 120 129 182 125 107
   114 114 114 129 194 240 170  95 104 113 123 132 140 196 148 108
   114 114 138 208 240 234 230 171 116 125 134 143 165 206 143 114
   114 124 206 240 235 231 233 235 191 135 144 168 209 184 120 114
   114 188 235 242 231 233 236 238 241 211 170 211 195 137 114 114
   114 209 243 232 234 237 239 242 243 246 242 208 154 114 114 114
   114 206 242 237 237 240 242 244 247 252 232 165 114 114 114 114
   114 161 232 247 240 242 244 248 252 236 168 114 114 114 114 114
   114 118 215 244 249 247 250 252 239 171 114 114 114 114 114 114
   114 114 123 217 237 244 244 240 171 114 114 114 114 114 114 114
   114 114 114 116 152 188 172 132 114 114 114 114 114 114 114 114
   114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114];
%
% PICKER
img(:,:,3) = ...
 [ 114 114 114 114 114 114 114 114 114 114  86  81  81  81  74 114
   114 114 114 114 114 114 114 114 114 114  81 118 184 150  81 114
   114 114 114 114 114 114 114 114 114  91  81 184 126  81  81 114
   114 114 114 114 114 114 114  81  81 126 118 137  81  81  81 114
   114 114 114 114 114 114 114  90  81 184  81  81  81  81  90 114
   114 114 114 114 114 114  90 158 254  81  81  81  88 114 114 114
   114 114 114 114 114 113 158 254 235 216  81  81 114 114 114 114
   114 114 114 114  92 158 254 235 216 158  94  81 114 114 114 114
   114 114 114 114 158 254 225 209 158  94 114 114 114 114 114 114
   114 114 114  90 158 184 184 158  93 114 114 114 114 114 114 114
   114 114 114 158 184 184 158  92 114 114 114 114 114 114 114 114
   114 114 121 160 138  90 114 114 114 114 114 114 114 114 114 114
   114 114 139 184 139  99 114 114 114 114 114 114 114 114 114 114
   114 114 160 219 160 114 114 114 114 114 114 114 114 114 114 114
   114 114 137 160 137 114 114 114 114 114 114 114 114 114 114 114
   114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 ];
%
% BUCKET
img(:,:,4) = ...
 [ 114 114 114 114 114 114 114 114 100  90  85  85  91 100 114 114
   114 114 114 114 114 114 114 114  90  90  99  99  90  91 114 114
   114 114 114 114 114 114 114 114  83  98  92  94 101  83 114 114
   114 114 114 114 114 114 114 101  83  98 197  94 100  83 114 114
   114 114 114 114 114 114  95  90  83 248 242 197  93  83 114 114
   109 143 154 154 137 100 149 245  83 221 207 245 117  83 114 114
   141 189 207 121 115 232 254 214  85  99 182 218 229  83 114 114
   153 234 101 163 250 241 251  98 122 129 107 207 238 159  95 114
   154 240 139 112 249 223 240 105 126 142 111 212 209 245  96 100
   154 240 154  93 195 236 229 217 114 119 206 218 208 227 200  93
   154 240 154 101  93 246 224 238 253 243 233 224 213 220 250  88
   154 230 153 114  94 159 242 227 246 249 239 231 243 242 140  93
   139 154 139 114 114  90 232 228 236 254 249 252 191  91  95 114
   114 107 114 114 114  97 122 247 234 253 230 108  95 101 114 114
   114 114 114 114 114 114  92 197 240 145  94  98 114 114 114 114
   114 114 114 114 114 114 100  90  89  95 114 114 114 114 114 114 ];
%
% GRID
img(:,:,5) = ...
 [ 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114
   114 133 133 133 133 133 133 133 133 133 133 133 133 133 133 114
   114 133 255 255 255 182 255 255 255 255 182 255 255 255 133 114
   114 133 255 236 236 182 236 236 236 236 182 236 236 255 133 114
   114 133 255 236 236 182 236 236 236 236 182 236 236 255 133 114
   114 133 182 182 182 182 182 182 182 182 182 182 182 182 133 114
   114 133 255 236 236 182 236 236 236 236 182 236 236 255 133 114
   114 133 255 236 236 182 236 236 236 236 182 236 236 255 133 114
   114 133 255 236 236 182 236 236 236 236 182 236 236 255 133 114 
   114 133 255 236 236 182 236 236 236 236 182 236 236 255 133 114
   114 133 182 182 182 182 182 182 182 182 182 182 182 182 133 114
   114 133 255 236 236 182 236 236 236 236 182 236 236 255 133 114
   114 133 255 236 236 182 236 236 236 236 182 236 236 255 133 114
   114 133 255 255 255 182 255 255 255 255 182 255 255 255 133 114
   114 133 133 133 133 133 133 133 133 133 133 133 133 133 133 114
   114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 ];
%
% UNDO
img(:,:,6) = ...
 [ 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114
   114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114
   114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114
   111 103 114 114 114 114 104 112 112 105 104 101 101 114 114 114
   131 114 103 114 103 117 142 204 204 208 189 149  97  98 114 114
   131 208 127 107 122 207 237 223 219 215 210 202 162  93  99 114
   131 255 214 123 219 238 229 230 236 222 210 198 187 134  90 114
   131 255 254 250 242 234 239 235 129 108 104 114 114 158  94  97
   131 255 249 246 240 244 228 114 103 114 114 114  99 127 115  93
   131 255 249 245 245 252 115 104 114 114 114 114 100 124 137  90
   131 255 251 246 242 249 226 113 103 114 114 114 114  96 166  88
   131 255 254 252 250 248 255 219 110 114 114 114 114  97 162  87
   132 160 156 150 145 140 134 114 107 104 114 114 114  99  91  95
   114 103 103 114 114 114 114 114 114 114 114 114 114 114 114 114
   114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114
   114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 114 ];
%
% REDO
img(:,:,7) = fliplr(img(:,:,6));
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% I LOVE MATLAB... and you? :) %%%         