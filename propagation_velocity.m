%Script to create propagation trajectories and propagation velosities of
%viscous waves
%Using Comsol Livelink required
clear; clc; close all;

%Comsol file:
mph_filename='Example_L1_M5.mph';
%conditions
LL=1;     %source dimensionless length  
time_start=479; %ms
time_end=600; %ms
delta=0.002753; %the boundary layer thickness

x0_start=0; %const
y0_start=-LL/2;
y0_end=LL/2;
y0_step=LL/20;

plot_group_name_KSI='pg60';
export_plot_name_KSI='plot60';
plot_group_name=['pg32';'pg33'];
plot_export_name=['plot02';'plot03'];
prefix_name=['vx';'uy'];

%Creation of propagation trajectories
model = mphload(mph_filename);
model.result.create(plot_group_name_KSI, 'PlotGroup2D');
model.result(plot_group_name_KSI).create('str1', 'Streamline');
model.result(plot_group_name_KSI).set('looplevel', {'interp'});
model.result(plot_group_name_KSI).setIndex('interp', '0' , 0);
model.result(plot_group_name_KSI).feature('str1').set('expr', {'-v' 'u'});
model.result(plot_group_name_KSI).feature('str1').set('descr', '');
model.result(plot_group_name_KSI).feature('str1').set('posmethod', 'start');
model.result(plot_group_name_KSI).feature('str1').set('startmethod', 'coord');
model.result(plot_group_name_KSI).feature('str1').set('xcoord', [num2str(x0_start) '*delta']);
model.result(plot_group_name_KSI).feature('str1').set('ycoord', ...
    ['range(' num2str(y0_start) ',' num2str(y0_step) ',' num2str(y0_end) ')*delta']);
model.result(plot_group_name_KSI).feature('str1').set('resolution', 'normal');
model.result(plot_group_name_KSI).feature('str1').create('col1', 'Color');
model.result(plot_group_name_KSI).feature('str1').feature('col1').set('expr', 'spf.U/omega/delta');
model.result(plot_group_name_KSI).feature('str1').feature('col1').set('unit', '1');
model.result(plot_group_name_KSI).feature('str1').feature('col1').set('descr', 'spf.U/omega/delta');
model.result.export.create(export_plot_name_KSI, plot_group_name_KSI, 'str1', 'Plot');
for d1=1:time_end-time_start+1
    time0(d1)=(d1-1+time_start)*1e-4;
    text_file_name=['D:\FizFack\ÑOMSOL_WITH_MATLAB\Thin_Plate_A5L1_KSI_LINES\Transposed_streamline_new_method.txt'];
    model.result(plot_group_name_KSI).set('interp', {num2str(time0(d1))});
    model.result(plot_group_name_KSI).run;
    model.result.export(export_plot_name_KSI).set('filename',text_file_name);
    model.result.export(export_plot_name_KSI).run;
    data0 = data_file_read(text_file_name);
    for d0=data0(1,3):max(data0(:,3))
        nums0=find(data0(:,3)==d0);
        data1=data0(nums0,[1 2 4]);
        [val1(d1,d0+1), nums1]=max(data1(:,3));
        x1(d1,d0+1)=data1(nums1,1);
        y1(d1,d0+1)=data1(nums1,2);
        
    end
    x_range=[num2str(x1(d1,1)) ', '];
    y_range=[num2str(y1(d1,1)) ', '];
    for d3=2:d0
        x_range=[x_range num2str(x1(d1,d3)) ', '];
        y_range=[y_range num2str(y1(d1,d3)) ', '];
    end
    x_range=[x_range num2str(x1(d1,end))];
    y_range=[y_range num2str(y1(d1,end))];
    model.result(plot_group_name_KSI).feature('str1').set('xcoord', x_range);
    model.result(plot_group_name_KSI).feature('str1').set('ycoord', y_range);
end

%calculation the propagation velocity
tau=2*pi*50*time0;
cx=diff(x1)./diff(tau);
cy=diff(y1)./diff(tau);
%use the smooth() function to apply moving average filter (if needed)

%saving all the data
save_text_file_data(x1,'x.txt',mph_filename)
save_text_file_data(y1,'y.txt',mph_filename)
save_text_file_data(cx,'cy.txt',mph_filename)
save_text_file_data(cy,'cx.txt',mph_filename)